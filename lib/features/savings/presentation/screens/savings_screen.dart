import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/features/savings/providers/savings_provider.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/features/savings/presentation/widgets/add_contribution_sheet.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savingsProvider);

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
                color: AppColors.income, // Use Green (income) as per earlier logic, or Tosca based on design.md
                // Wait, design.md says Saving = Tosca (#95E1D3)
                // AppColors.saving is likely Tosca. Let's use AppColors.saving
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tabungan',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.push('/add-savings-goal'),
                        icon: const Icon(Icons.add_circle, color: AppColors.surface, size: 32),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.activeGoals.isEmpty && state.achievedGoals.isEmpty
                          ? _buildEmptyState(context)
                          : ListView(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s48),
                              children: [
                                if (state.activeGoals.isNotEmpty) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                                    child: Text('Sedang Berjalan', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                                  ),
                                  ...state.activeGoals.map((g) => _buildGoalCard(context, ref, g)),
                                ],
                                if (state.achievedGoals.isNotEmpty) ...[
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
                                    child: Text('Sudah Tercapai 🥳', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                                  ),
                                  ...state.achievedGoals.map((g) => _buildGoalCard(context, ref, g, isAchieved: true)),
                                ],
                              ],
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, WidgetRef ref, SavingsGoal goal, {bool isAchieved = false}) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final percentage = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final pctString = '${(percentage * 100).toStringAsFixed(0)}%';

    return GestureDetector(
      onTap: () {
        if (!isAchieved) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => AddContributionSheet(goal: goal),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s8),
        padding: const EdgeInsets.all(AppSpacing.s20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondary, AppColors.softAccent], // #95E1D3 to #EAFFD0
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    pctString,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              '${currencyFormat.format(goal.currentAmount)} / ${currencyFormat.format(goal.targetAmount)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            // Progress Bar
            Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.75 * percentage, // approximate width
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Using Coral for the fill looks nice on Tosca
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.momoHappy, // Pretend this is Momo putting coin into piggy bank
            width: 150,
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Belum ada tabungan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Yuk mulai rencanakan target tabunganmu!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s32),
          ElevatedButton.icon(
            onPressed: () => context.push('/add-savings-goal'),
            icon: const Icon(Icons.add, color: AppColors.surface),
            label: const Text('Buat Tabungan Baru'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saving,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
            ),
          ),
        ],
      ),
    );
  }
}
