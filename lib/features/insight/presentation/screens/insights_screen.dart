import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/features/insight/providers/insight_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(insightProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header & Month Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Insights',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => ref.read(insightProvider.notifier).changeMonth(-1),
                      ),
                      Text(
                        DateFormat('MMM yyyy', 'id_ID').format(state.currentMonth),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => ref.read(insightProvider.notifier).changeMonth(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.totalIncome == 0 && state.totalExpense == 0 && state.totalSavings == 0
                      ? _buildEmptyState(context)
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                          children: [
                            // Summary Cards
                            Row(
                              children: [
                                Expanded(child: _buildSummaryCard(context, 'Masuk', state.totalIncome, AppColors.income)),
                                const SizedBox(width: AppSpacing.s12),
                                Expanded(child: _buildSummaryCard(context, 'Keluar', state.totalExpense, AppColors.expense)),
                                const SizedBox(width: AppSpacing.s12),
                                Expanded(child: _buildSummaryCard(context, 'Nabung', state.totalSavings, AppColors.saving)),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s32),

                            // Insight Card
                            if (state.topCategoryName != null)
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.s20),
                                decoration: BoxDecoration(
                                  color: AppColors.softAccent, // #FCE38A
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(AppAssets.momoThinking, width: 60),
                                    const SizedBox(width: AppSpacing.s16),
                                    Expanded(
                                      child: Text(
                                        'Bulan ini kategori ${state.topCategoryName} paling sering muncul.',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: AppSpacing.s32),

                            // Donut Chart
                            if (state.expensesByCategory.isNotEmpty) ...[
                              Text(
                                'Pengeluaran Kategori',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s24),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 50,
                                    sections: _buildPieChartSections(state.expensesByCategory),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              _buildLegend(state.expensesByCategory),
                              const SizedBox(height: AppSpacing.s32),
                            ],

                            // Weekly Bar Chart
                            if (state.weeklyExpenses.any((val) => val > 0)) ...[
                              Text(
                                'Tren Mingguan',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s24),
                              SizedBox(
                                height: 200,
                                child: BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    barTouchData: BarTouchData(enabled: false),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text('W${value.toInt() + 1}', style: const TextStyle(fontSize: 12)),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    gridData: const FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                    barGroups: state.weeklyExpenses.asMap().entries.map((e) {
                                      return BarChartGroupData(
                                        x: e.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value,
                                            color: AppColors.expense,
                                            width: 16,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color color) {
    final format = NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s4),
          Text(
            format.format(amount),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> expenses) {
    final colors = [
      AppColors.expense,
      AppColors.primary,
      AppColors.secondary,
      AppColors.info,
      Colors.purple[300]!,
      Colors.orange[300]!,
    ];
    
    int i = 0;
    return expenses.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: '', // don't show title on chart, use legend
        radius: 40,
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> expenses) {
    final colors = [
      AppColors.expense,
      AppColors.primary,
      AppColors.secondary,
      AppColors.info,
      Colors.purple[300]!,
      Colors.orange[300]!,
    ];
    
    int i = 0;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: expenses.entries.map((e) {
        final color = colors[i % colors.length];
        i++;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
            const SizedBox(width: 8),
            Text(e.key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.momoAnalyzingSpending,
            width: 150,
            errorBuilder: (c, e, s) => Image.asset(AppAssets.momoThinking, width: 150),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Belum ada data',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Catat transaksimu untuk melihat ringkasan bulan ini.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
