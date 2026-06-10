import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:drift/drift.dart';

class SavingsState {
  final List<SavingsGoal> activeGoals;
  final List<SavingsGoal> achievedGoals;
  final bool isLoading;

  SavingsState({
    this.activeGoals = const [],
    this.achievedGoals = const [],
    this.isLoading = true,
  });

  SavingsState copyWith({
    List<SavingsGoal>? activeGoals,
    List<SavingsGoal>? achievedGoals,
    bool? isLoading,
  }) {
    return SavingsState(
      activeGoals: activeGoals ?? this.activeGoals,
      achievedGoals: achievedGoals ?? this.achievedGoals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SavingsNotifier extends Notifier<SavingsState> {
  late final AppDatabase _db;

  @override
  SavingsState build() {
    _db = ref.watch(databaseProvider);
    Future.microtask(() => loadGoals());
    return SavingsState();
  }

  Future<void> loadGoals() async {
    state = state.copyWith(isLoading: true);
    
    final allGoals = await _db.select(_db.savingsGoals).get();
    
    final active = allGoals.where((g) => g.status == 'active').toList();
    final achieved = allGoals.where((g) => g.status == 'achieved').toList();
    
    state = state.copyWith(
      activeGoals: active,
      achievedGoals: achieved,
      isLoading: false,
    );
  }

  Future<void> addGoal(String title, double targetAmount) async {
    // We assume user id 1 for now since we only have 1 default user
    await _db.into(_db.savingsGoals).insert(
      SavingsGoalsCompanion.insert(
        userId: 1,
        title: title,
        targetAmount: targetAmount,
        currentAmount: const Value(0.0),
        status: const Value('active'),
      ),
    );
    await loadGoals();
  }

  Future<void> addContribution(int goalId, double amount, String note) async {
    await _db.transaction(() async {
      // Get the goal
      final goal = await (_db.select(_db.savingsGoals)..where((t) => t.id.equals(goalId))).getSingle();
      
      final newAmount = goal.currentAmount + amount;
      final newStatus = newAmount >= goal.targetAmount ? 'achieved' : 'active';
      
      // Update goal
      await (_db.update(_db.savingsGoals)..where((t) => t.id.equals(goalId))).write(
        SavingsGoalsCompanion(
          currentAmount: Value(newAmount),
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
      
      // Insert contribution log
      await _db.into(_db.savingsContributions).insert(
        SavingsContributionsCompanion.insert(
          savingsGoalId: goalId,
          amount: amount,
          contributionDate: DateTime.now(),
        ),
      );
      
      // We also need to insert it as a transaction so it appears in History.
      // We'll assign it to the default wallet (id 1) and 'Tabungan' category.
      // First find the 'Tabungan' category:
      final category = await (_db.select(_db.categories)..where((c) => c.name.equals('Tabungan'))).getSingleOrNull();
      final wallet = await (_db.select(_db.wallets)..where((w) => w.isDefault.equals(true))).getSingleOrNull();
      
      if (category != null && wallet != null) {
        await _db.into(_db.transactions).insert(
          TransactionsCompanion.insert(
            userId: 1,
            walletId: wallet.id,
            categoryId: category.id,
            type: 'savings',
            amount: amount,
            note: Value(note.isNotEmpty ? note : 'Nabung untuk ${goal.title}'),
            transactionDate: DateTime.now(),
            source: const Value('savings_goal'),
          ),
        );
      }
    });
    
    await loadGoals();
  }
}

final savingsProvider = NotifierProvider<SavingsNotifier, SavingsState>(SavingsNotifier.new);
