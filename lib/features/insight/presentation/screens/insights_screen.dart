import 'package:flutter/material.dart';

import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_spacing.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Curved Header Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.secondary,
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
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  child: Text(
                    'Insights',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
                ),
                // Placeholder overlapping card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                  child: Container(
                    height: 100,
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
                    alignment: Alignment.center,
                    child: Text('Insights (TBD)', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
