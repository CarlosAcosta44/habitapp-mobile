// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(habitsRepository)
final habitsRepositoryProvider = HabitsRepositoryProvider._();

final class HabitsRepositoryProvider
    extends
        $FunctionalProvider<
          HabitsRepository,
          HabitsRepository,
          HabitsRepository
        >
    with $Provider<HabitsRepository> {
  HabitsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitsRepositoryHash();

  @$internal
  @override
  $ProviderElement<HabitsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HabitsRepository create(Ref ref) {
    return habitsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HabitsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HabitsRepository>(value),
    );
  }
}

String _$habitsRepositoryHash() => r'd9e113e5552ae110ed32ff8f577f234f4e0fde9e';
