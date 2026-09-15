// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileStats)
final profileStatsProvider = ProfileStatsProvider._();

final class ProfileStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStats>,
          UserStats,
          FutureOr<UserStats>
        >
    with $FutureModifier<UserStats>, $FutureProvider<UserStats> {
  ProfileStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileStatsHash();

  @$internal
  @override
  $FutureProviderElement<UserStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserStats> create(Ref ref) {
    return profileStats(ref);
  }
}

String _$profileStatsHash() => r'03735c5f5005316d0f50f9c1a15e981bbc95b77a';

@ProviderFor(ProfileNotifier)
final profileProvider = ProfileNotifierProvider._();

final class ProfileNotifierProvider
    extends $AsyncNotifierProvider<ProfileNotifier, UserProfile?> {
  ProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();
}

String _$profileNotifierHash() => r'b11d8c75ab47091e3439972ff40174c8740e5774';

abstract class _$ProfileNotifier extends $AsyncNotifier<UserProfile?> {
  FutureOr<UserProfile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile?>, UserProfile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile?>, UserProfile?>,
              AsyncValue<UserProfile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
