import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/core/constants/app_colors.dart';
import 'package:sakuin/core/constants/app_radius.dart';
import 'package:sakuin/core/constants/app_spacing.dart';
import 'package:sakuin/features/onboarding/presentation/providers/onboarding_provider.dart';

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
      'color': AppColors.primary,
    },
    {
      'title': 'Scan struk, tinggal review',
      'color': AppColors.secondary,
    },
    {
      'title': 'Nabung jadi kelihatan',
      'color': AppColors.softAccent,
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
                        // Mascot Placeholder
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            color: slide['color'],
                            borderRadius: BorderRadius.circular(AppRadius.large),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 100,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s48),
                        Text(
                          slide['title'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
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
