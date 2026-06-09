import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/widgets/app_background.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/savings')) return 2;
    if (location.startsWith('/insights')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/savings');
        break;
      case 3:
        context.go('/insights');
        break;
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.income,
                    child: Icon(Icons.add, color: AppColors.surface),
                  ),
                  title: const Text('Tambah Pemasukan'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-transaction?type=income');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.expense,
                    child: Icon(Icons.remove, color: AppColors.surface),
                  ),
                  title: const Text('Tambah Pengeluaran'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-transaction?type=expense');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.info,
                    child: Icon(Icons.document_scanner, color: AppColors.surface),
                  ),
                  title: const Text('Scan OCR'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to OCR screen
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AppBackground(),
          child,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BottomAppBar(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.surface,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _buildNavItem(context, icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', index: 0, currentIndex: currentIndex),
                  _buildNavItem(context, icon: Icons.history_outlined, activeIcon: Icons.history, label: 'Riwayat', index: 1, currentIndex: currentIndex),
                  const SizedBox(width: 48), // Space for FAB
                  _buildNavItem(context, icon: Icons.savings_outlined, activeIcon: Icons.savings, label: 'Tabungan', index: 2, currentIndex: currentIndex),
                  _buildNavItem(context, icon: Icons.insights_outlined, activeIcon: Icons.insights, label: 'Insight', index: 3, currentIndex: currentIndex),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index, context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
