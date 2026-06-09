import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/core/providers/user_provider.dart';
import 'package:sakuin/database/database_provider.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Curved Header Background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                ),
              ),
              // Content
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s16),
                      child: _buildHeader(context, theme, ref),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: _buildBalanceCard(context, db, theme),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: _buildQuickActions(context),
                    ),
                    const SizedBox(height: AppSpacing.s32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                      child: Text(
                        'Recent Transactions',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    _buildRecentTransactions(context, db, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo,',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.surface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            userAsync.when(
              data: (user) => Text(
                user.name,
                style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
              ),
              loading: () => const CircularProgressIndicator(color: AppColors.surface),
              error: (err, stack) => Text('User', style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        userAsync.when(
          data: (user) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface.withValues(alpha: 0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: user.avatar != null ? Colors.transparent : AppColors.surface.withValues(alpha: 0.2),
              child: user.avatar != null 
                  ? Image.asset(user.avatar!, width: 48, height: 48)
                  : const Icon(Icons.person, color: AppColors.surface),
            ),
          ),
          loading: () => const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
          ),
          error: (err, stack) => const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person, color: AppColors.surface),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, AppDatabase db, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)], // Solid Coral gradient for readability
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sisa bulan ini',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                StreamBuilder(
                  stream: db.select(db.wallets).watch(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: AppColors.surface);
                    }
                    
                    final List<Wallet> wallets = snapshot.data ?? [];
                    final totalBalance = wallets.fold<double>(
                      0,
                      (sum, wallet) => sum + wallet.balance,
                    );

                    final currencyFormat = NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    );

                    return Text(
                      currencyFormat.format(totalBalance),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Masih aman untuk hari ini',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            AppAssets.momoHappy, // Dynamic state logic later
            width: 80,
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickActionItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Pengeluaran',
            onTap: () => context.push('/add-transaction?type=expense'),
          ),
          _QuickActionItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Pemasukan',
            onTap: () => context.push('/add-transaction?type=income'),
          ),
          _QuickActionItem(
            icon: Icons.document_scanner_outlined,
            label: 'Scan Struk',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context, AppDatabase db, ThemeData theme) {
    return StreamBuilder(
      stream: (db.select(db.transactions)
            ..orderBy([
              (t) => drift.OrderingTerm(expression: t.transactionDate, mode: drift.OrderingMode.desc)
            ])
            ..limit(5))
          .watch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Transaction> transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.s24),
                Image.asset(
                  AppAssets.emptyTransaction,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  'Belum ada transaksi',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Mulai catat satu transaksi kecil dulu.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const Divider(height: AppSpacing.s16),
          itemBuilder: (context, index) {
            final tx = transactions[index];
            final isIncome = tx.type == 'income';
            
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: isIncome ? AppColors.income.withValues(alpha: 0.1) : AppColors.expense.withValues(alpha: 0.1),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? AppColors.income : AppColors.expense,
                ),
              ),
              title: Text(tx.note ?? 'No Note', style: theme.textTheme.bodyLarge),
              subtitle: Text(
                DateFormat('MMM dd, HH:mm').format(tx.transactionDate),
                style: theme.textTheme.bodySmall,
              ),
              trailing: Text(
                '${isIncome ? '+' : '-'} Rp ${NumberFormat('#,###', 'id_ID').format(tx.amount)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isIncome ? AppColors.income : AppColors.expense,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: AppSpacing.s8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
