import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingSlide extends _$OnboardingSlide {
  @override
  int build() => 0;

  void setSlide(int index) {
    state = index;
  }

  void nextSlide() {
    if (state < 2) {
      state++;
    }
  }
}
