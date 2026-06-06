// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingSlide)
final onboardingSlideProvider = OnboardingSlideProvider._();

final class OnboardingSlideProvider
    extends $NotifierProvider<OnboardingSlide, int> {
  OnboardingSlideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingSlideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingSlideHash();

  @$internal
  @override
  OnboardingSlide create() => OnboardingSlide();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$onboardingSlideHash() => r'9b622edf3d9eeab4ff1c68fe44f2dcc71c343e3d';

abstract class _$OnboardingSlide extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
