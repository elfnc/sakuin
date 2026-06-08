import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/core/constants/app_assets.dart';
import 'package:sakuin/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sakuin/database/database_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Catat uang tanpa ribet',
      'body': 'Lacak setiap pengeluaran dan pemasukan dengan mudah dan rapi.',
      'cardIcon': Icons.account_balance_wallet,
      'cardLabel': 'Track',
      'color': AppColors.primary,
      'imagePath': AppAssets.onboarding1,
    },
    {
      'title': 'Scan struk, tinggal review',
      'body': 'Otomatis baca struk belanja kamu tanpa perlu ketik manual.',
      'cardIcon': Icons.receipt_long,
      'cardLabel': 'Scan',
      'color': AppColors.secondary,
      'imagePath': AppAssets.onboarding2,
    },
    {
      'title': 'Nabung jadi kelihatan',
      'body': 'Pantau progress target tabungan kamu sampai terkumpul.',
      'cardIcon': Icons.savings,
      'cardLabel': 'Savings',
      'color': AppColors.softAccent,
      'imagePath': AppAssets.onboarding3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onSkipOrComplete() async {
    final db = ref.read(databaseProvider);
    final settings = await db.select(db.appSettings).getSingleOrNull();
    if (settings != null) {
      await db.update(db.appSettings).replace(
        settings.copyWith(isOnboardingCompleted: true),
      );
    }
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = ref.watch(onboardingSlideProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onSkipOrComplete,
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ),
            
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(onboardingSlideProvider.notifier).setSlide(index);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.s24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Top Illustration
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s24),
                          decoration: BoxDecoration(
                            color: slide['color'].withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadius.large),
                          ),
                          child: Center(
                            child: Image.asset(
                              slide['imagePath'],
                              width: 220,
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s32),
                        // Headline
                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        // Body Text
                        Text(
                          slide['body'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s32),
                        // Card + Icon + Label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(slide['cardIcon'], color: AppColors.primary),
                              const SizedBox(width: AppSpacing.s8),
                              Text(
                                slide['cardLabel'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot indicator
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: AppSpacing.s8),
                        width: currentSlide == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentSlide == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ),

                  // Next / Mulai button
                  ElevatedButton(
                    onPressed: () {
                      if (currentSlide == _slides.length - 1) {
                        _onSkipOrComplete();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(currentSlide == _slides.length - 1 ? 'Mulai' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
