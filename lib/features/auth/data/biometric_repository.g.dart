// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(biometricRepository)
final biometricRepositoryProvider = BiometricRepositoryProvider._();

final class BiometricRepositoryProvider
    extends
        $FunctionalProvider<
          BiometricRepository,
          BiometricRepository,
          BiometricRepository
        >
    with $Provider<BiometricRepository> {
  BiometricRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricRepositoryHash();

  @$internal
  @override
  $ProviderElement<BiometricRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BiometricRepository create(Ref ref) {
    return biometricRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricRepository>(value),
    );
  }
}

String _$biometricRepositoryHash() =>
    r'a49ab0c1fabe0613f89dd1aa22b0586ddeec953b';
