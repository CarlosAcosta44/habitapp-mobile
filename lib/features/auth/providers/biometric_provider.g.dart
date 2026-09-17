// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BiometricNotifier)
final biometricProvider = BiometricNotifierProvider._();

final class BiometricNotifierProvider
    extends $AsyncNotifierProvider<BiometricNotifier, BiometricState> {
  BiometricNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricNotifierHash();

  @$internal
  @override
  BiometricNotifier create() => BiometricNotifier();
}

String _$biometricNotifierHash() => r'ba90d02d021919ac617658da82bb1440e71b40bb';

abstract class _$BiometricNotifier extends $AsyncNotifier<BiometricState> {
  FutureOr<BiometricState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BiometricState>, BiometricState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BiometricState>, BiometricState>,
              AsyncValue<BiometricState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
