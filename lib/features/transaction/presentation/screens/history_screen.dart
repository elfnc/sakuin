import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/features/transaction/providers/transaction_history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionHistoryProvider);
    final notifier = ref.read(transactionHistoryProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Curved Header Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.info, // Use Info (blue) per design
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                  child: Text(
                    'Riwayat Transaksi',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Search & Filter Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => notifier.setSearchQuery(val),
                            decoration: InputDecoration(
                              icon: const Icon(Icons.search, color: AppColors.textSecondary),
                              hintText: 'Cari catatan...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        
                        // Time Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Hari ini', 'Minggu ini', 'Bulan ini'].map((timeStr) {
                              final isSelected = state.timeFilter == timeStr;
                              return Padding(
                                padding: const EdgeInsets.only(right: AppSpacing.s8),
                                child: FilterChip(
                                  label: Text(timeStr),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    notifier.setTimeFilter(val ? timeStr : null);
                                  },
                                  selectedColor: AppColors.info.withValues(alpha: 0.2),
                                  checkmarkColor: AppColors.info,
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.info : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: isSelected ? AppColors.info : AppColors.border,
                                    ),
                                  ),
                                  backgroundColor: AppColors.surface,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: AppSpacing.s8),
                        
                        // Type Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Masuk', 'Keluar', 'Tabungan'].map((typeStr) {
                              final isSelected = state.typeFilters.contains(typeStr);
                              return Padding(
                                padding: const EdgeInsets.only(right: AppSpacing.s8),
                                child: FilterChip(
                                  label: Text(typeStr),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    notifier.toggleTypeFilter(typeStr);
                                  },
                                  selectedColor: AppColors.info.withValues(alpha: 0.2),
                                  checkmarkColor: AppColors.info,
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.info : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: isSelected ? AppColors.info : AppColors.border,
                                    ),
                                  ),
                                  backgroundColor: AppColors.surface,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.s24),
                
                // Transactions List
                Expanded(
                  child: state.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : state.transactions.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(AppSpacing.s24, 0, AppSpacing.s24, AppSpacing.s48),
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            final item = state.transactions[index];
                            return _buildTransactionItem(context, item);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionWithCategory item) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isIncome = item.transaction.type == 'income';
    
    Color amountColor = AppColors.expense; // default coral
    String sign = '-';
    
    if (isIncome) {
      amountColor = AppColors.income;
      sign = '+';
    } else if (item.transaction.type == 'savings') {
      amountColor = AppColors.saving;
      sign = '-'; // money goes to savings
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.receipt_long, // Ideally based on item.category.icon
              color: amountColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item.transaction.note != null && item.transaction.note!.isNotEmpty)
                  Text(
                    item.transaction.note!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          // Amount & Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign${currencyFormat.format(item.transaction.amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd MMM, HH:mm').format(item.transaction.transactionDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.momoCalm, // Pretend this is sleeping Momo for now
            width: 150,
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Belum ada transaksi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Mulai catat satu transaksi kecil dulu.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s48),
        ],
      ),
    );
  }
}
