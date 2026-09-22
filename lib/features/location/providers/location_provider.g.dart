// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'347d171ff0e8ffe39618ec7b7608be7bd7c86f0a';

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
    r'935ae7d03af2054548eea270a08904541f8b1f44';

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
