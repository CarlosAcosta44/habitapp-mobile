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

String _$biometricNotifierHash() => r'5eea0798b327ae0079dc29796bebff23d53567be';

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
