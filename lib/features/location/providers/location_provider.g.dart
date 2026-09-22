// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationRepository)
final locationRepositoryProvider = LocationRepositoryProvider._();

final class LocationRepositoryProvider
    extends
        $FunctionalProvider<
          LocationRepository,
          LocationRepository,
          LocationRepository
        >
    with $Provider<LocationRepository> {
  LocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationRepository create(Ref ref) {
    return locationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationRepository>(value),
    );
  }
}

String _$locationRepositoryHash() =>
    r'51b663d87478af694528b835bfd86e5ee885cb4d';

@ProviderFor(UserLocationNotifier)
final userLocationProvider = UserLocationNotifierProvider._();

final class UserLocationNotifierProvider
    extends $AsyncNotifierProvider<UserLocationNotifier, (Position, String)?> {
  UserLocationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocationNotifierHash();

  @$internal
  @override
  UserLocationNotifier create() => UserLocationNotifier();
}

String _$userLocationNotifierHash() =>
    r'a3b35c6ae6c27eb68d58066f05bb7f53d4065e36';

abstract class _$UserLocationNotifier
    extends $AsyncNotifier<(Position, String)?> {
  FutureOr<(Position, String)?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<(Position, String)?>, (Position, String)?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<(Position, String)?>, (Position, String)?>,
              AsyncValue<(Position, String)?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
