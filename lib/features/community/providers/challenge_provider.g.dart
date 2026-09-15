// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChallengesNotifier)
final challengesProvider = ChallengesNotifierProvider._();

final class ChallengesNotifierProvider
    extends $AsyncNotifierProvider<ChallengesNotifier, List<Challenge>> {
  ChallengesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengesNotifierHash();

  @$internal
  @override
  ChallengesNotifier create() => ChallengesNotifier();
}

String _$challengesNotifierHash() =>
    r'a9a98a96fb91552074d54267978774eef04f5253';

abstract class _$ChallengesNotifier extends $AsyncNotifier<List<Challenge>> {
  FutureOr<List<Challenge>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Challenge>>, List<Challenge>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Challenge>>, List<Challenge>>,
              AsyncValue<List<Challenge>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
