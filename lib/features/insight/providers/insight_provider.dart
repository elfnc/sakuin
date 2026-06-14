import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:drift/drift.dart';

class InsightState {
  final bool isLoading;
  final double totalIncome;
  final double totalExpense;
  final double totalSavings;
  final Map<String, double> expensesByCategory;
  final List<double> weeklyExpenses;
  final String? topCategoryName;
  final DateTime currentMonth;

  const InsightState({
    this.isLoading = true,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.totalSavings = 0,
    this.expensesByCategory = const {},
    this.weeklyExpenses = const [],
    this.topCategoryName,
    required this.currentMonth,
  });

  InsightState copyWith({
    bool? isLoading,
    double? totalIncome,
    double? totalExpense,
    double? totalSavings,
    Map<String, double>? expensesByCategory,
    List<double>? weeklyExpenses,
    String? topCategoryName,
    DateTime? currentMonth,
  }) {
    return InsightState(
      isLoading: isLoading ?? this.isLoading,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      totalSavings: totalSavings ?? this.totalSavings,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      weeklyExpenses: weeklyExpenses ?? this.weeklyExpenses,
      topCategoryName: topCategoryName ?? this.topCategoryName,
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }
}

class InsightNotifier extends Notifier<InsightState> {
  @override
  InsightState build() {
    final now = DateTime.now();
    final initialMonth = DateTime(now.year, now.month, 1);
    
    // Future microtask to avoid changing state while building
    Future.microtask(() => loadInsights(initialMonth));
    
    return InsightState(currentMonth: initialMonth);
  }

  Future<void> loadInsights(DateTime month) async {
    state = state.copyWith(isLoading: true, currentMonth: month);
    
    final db = ref.read(databaseProvider);
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final transactions = await (db.select(db.transactions)
          ..where((t) => t.transactionDate.isBetweenValues(startOfMonth, endOfMonth)))
        .get();
        
    final categories = await db.select(db.categories).get();
    final categoryMap = {for (var c in categories) c.id: c.name};

    var income = 0.0;
    var expense = 0.0;
    var savings = 0.0;
    final Map<String, double> byCategory = {};
    
    // 5 weeks max in a month for simplicity
    final List<double> weekly = [0.0, 0.0, 0.0, 0.0, 0.0];

    for (var t in transactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else if (t.type == 'saving') {
        savings += t.amount;
      } else if (t.type == 'expense') {
        expense += t.amount;
        
        final catName = categoryMap[t.categoryId] ?? 'Lainnya';
        byCategory[catName] = (byCategory[catName] ?? 0) + t.amount;
        
        int weekIndex = (t.transactionDate.day - 1) ~/ 7;
        if (weekIndex > 4) weekIndex = 4;
        weekly[weekIndex] += t.amount;
      }
    }

    String? topCat;
    double maxCatVal = 0;
    byCategory.forEach((key, value) {
      if (value > maxCatVal) {
        maxCatVal = value;
        topCat = key;
      }
    });

    state = state.copyWith(
      isLoading: false,
      totalIncome: income,
      totalExpense: expense,
      totalSavings: savings,
      expensesByCategory: byCategory,
      weeklyExpenses: weekly,
      topCategoryName: topCat,
    );
  }

  void changeMonth(int offset) {
    final newMonth = DateTime(state.currentMonth.year, state.currentMonth.month + offset, 1);
    loadInsights(newMonth);
  }
}

final insightProvider = NotifierProvider<InsightNotifier, InsightState>(() {
  return InsightNotifier();
});
