import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:drift/drift.dart';

class TransactionWithCategory {
  final Transaction transaction;
  final Category category;

  TransactionWithCategory({required this.transaction, required this.category});
}

class TransactionHistoryState {
  final List<TransactionWithCategory> transactions;
  final bool isLoading;
  final String searchQuery;
  final String? timeFilter; // 'Hari ini', 'Minggu ini', 'Bulan ini'
  final List<String> typeFilters; // 'Masuk', 'Keluar', 'Tabungan'

  TransactionHistoryState({
    this.transactions = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.timeFilter,
    this.typeFilters = const [],
  });

  TransactionHistoryState copyWith({
    List<TransactionWithCategory>? transactions,
    bool? isLoading,
    String? searchQuery,
    String? timeFilter,
    List<String>? typeFilters,
    bool clearTimeFilter = false,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      timeFilter: clearTimeFilter ? null : (timeFilter ?? this.timeFilter),
      typeFilters: typeFilters ?? this.typeFilters,
    );
  }
}

class TransactionHistoryNotifier extends Notifier<TransactionHistoryState> {
  late final AppDatabase _db;

  @override
  TransactionHistoryState build() {
    _db = ref.watch(databaseProvider);
    // Initial state setup is handled by fetching later or right away
    // Since we need async loading, let's trigger it and return empty initially
    Future.microtask(() => _loadTransactions());
    return TransactionHistoryState();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _loadTransactions();
  }

  void setTimeFilter(String? filter) {
    state = state.copyWith(
      timeFilter: filter,
      clearTimeFilter: filter == null,
    );
    _loadTransactions();
  }

  void toggleTypeFilter(String type) {
    final currentTypes = List<String>.from(state.typeFilters);
    if (currentTypes.contains(type)) {
      currentTypes.remove(type);
    } else {
      currentTypes.add(type);
    }
    state = state.copyWith(typeFilters: currentTypes);
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    state = state.copyWith(isLoading: true);

    final query = _db.select(_db.transactions).join([
      innerJoin(_db.categories, _db.categories.id.equalsExp(_db.transactions.categoryId)),
    ]);

    // Apply Search
    if (state.searchQuery.isNotEmpty) {
      final search = '%${state.searchQuery}%';
      query.where(_db.transactions.note.like(search) | _db.categories.name.like(search));
    }

    // Apply Time Filter
    if (state.timeFilter != null) {
      final now = DateTime.now();
      DateTime startDate;
      final todayStart = DateTime(now.year, now.month, now.day);
      
      if (state.timeFilter == 'Hari ini') {
        startDate = todayStart;
      } else if (state.timeFilter == 'Minggu ini') {
        startDate = todayStart.subtract(Duration(days: now.weekday - 1));
      } else { // 'Bulan ini'
        startDate = DateTime(now.year, now.month, 1);
      }
      
      query.where(_db.transactions.transactionDate.isBiggerOrEqualValue(startDate));
    }

    // Apply Type Filter
    if (state.typeFilters.isNotEmpty) {
      final typeMap = {
        'Masuk': 'income',
        'Keluar': 'expense',
        'Tabungan': 'savings', // Wait, saving goals might be recorded as savings type
      };
      
      final dbTypes = state.typeFilters.map((t) => typeMap[t] ?? t).toList();
      query.where(_db.transactions.type.isIn(dbTypes));
    }

    // Order by date descending
    query.orderBy([OrderingTerm.desc(_db.transactions.transactionDate)]);

    final rows = await query.get();
    final results = rows.map((row) {
      return TransactionWithCategory(
        transaction: row.readTable(_db.transactions),
        category: row.readTable(_db.categories),
      );
    }).toList();

    state = state.copyWith(transactions: results, isLoading: false);
  }
}

final transactionHistoryProvider = NotifierProvider<TransactionHistoryNotifier, TransactionHistoryState>(TransactionHistoryNotifier.new);
