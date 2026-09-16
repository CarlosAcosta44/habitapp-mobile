// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommunityRetosNotifier)
final communityRetosProvider = CommunityRetosNotifierProvider._();

final class CommunityRetosNotifierProvider
    extends $AsyncNotifierProvider<CommunityRetosNotifier, List<RetoModel>> {
  CommunityRetosNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityRetosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityRetosNotifierHash();

  @$internal
  @override
  CommunityRetosNotifier create() => CommunityRetosNotifier();
}

String _$communityRetosNotifierHash() =>
    r'2d2b5784520e8b3e3c28543bc10e2f7d3782b8f1';

abstract class _$CommunityRetosNotifier
    extends $AsyncNotifier<List<RetoModel>> {
  FutureOr<List<RetoModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<RetoModel>>, List<RetoModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RetoModel>>, List<RetoModel>>,
              AsyncValue<List<RetoModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
