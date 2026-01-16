// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingStorage)
final onboardingStorageProvider = OnboardingStorageProvider._();

final class OnboardingStorageProvider
    extends $AsyncNotifierProvider<OnboardingStorage, bool> {
  OnboardingStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStorageHash();

  @$internal
  @override
  OnboardingStorage create() => OnboardingStorage();
}

String _$onboardingStorageHash() => r'818d78b4cc47f2a7a0d32a3061d9c88749fa603d';

abstract class _$OnboardingStorage extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
