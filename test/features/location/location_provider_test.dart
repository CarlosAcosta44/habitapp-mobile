import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habitapp_frontend/features/location/data/repositories/location_repository.dart';
import 'package:habitapp_frontend/features/location/providers/location_provider.dart';

class FakeLocationRepository extends Fake implements LocationRepository {
  bool serviceEnabled;
  bool permissionGranted;
  Position? mockPosition;

  FakeLocationRepository({
    this.serviceEnabled = true,
    this.permissionGranted = true,
    this.mockPosition,
  });

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<bool> requestPermission() async => serviceEnabled && permissionGranted;

  @override
  Future<Position?> getCurrentPosition() async {
    if (!serviceEnabled || !permissionGranted) return null;
    return mockPosition;
  }
}

Position createBogotaPosition() {
  return Position(
    latitude: 4.7110,
    longitude: -74.0721,
    timestamp: DateTime(2026, 11, 9, 10, 0),
    accuracy: 5.0,
    altitude: 2640.0,
    altitudeAccuracy: 1.0,
    heading: 0.0,
    headingAccuracy: 1.0,
    speed: 0.0,
    speedAccuracy: 1.0,
  );
}

void main() {
  group('LocationRepository y UserLocationNotifier — GPS On-Device (UT-206 a UT-210)', () {
    // 1 (UT-206)
    test('UT-206: UserLocationNotifier con permiso concedido captura coordenadas de Bogotá (4.7110, -74.0721) on-device (US040)', () async {
      final fakeRepo = FakeLocationRepository(
        serviceEnabled: true,
        permissionGranted: true,
        mockPosition: createBogotaPosition(),
      );
      final container = ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLocationProvider.future);
      expect(result, isNotNull);
      expect(result!.$1.latitude, closeTo(4.7110, 0.0001));
      expect(result.$1.longitude, closeTo(-74.0721, 0.0001));
    });

    // 2 (UT-207)
    test('UT-207: UserLocationNotifier formatea respaldo local de coordenadas cuando el geocoder offline no está disponible', () async {
      final fakeRepo = FakeLocationRepository(
        serviceEnabled: true,
        permissionGranted: true,
        mockPosition: createBogotaPosition(),
      );
      final container = ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLocationProvider.future);
      expect(result, isNotNull);
      expect(result!.$2, contains('4.7110'));
      expect(result.$2, contains('-74.0721'));
    });

    // 3 (UT-208)
    test('UT-208: UserLocationNotifier con permiso denegado permanentemente retorna null limpiamente sin lanzar excepción', () async {
      final fakeRepo = FakeLocationRepository(
        serviceEnabled: true,
        permissionGranted: false,
        mockPosition: createBogotaPosition(),
      );
      final container = ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLocationProvider.future);
      expect(result, isNull);
    });

    // 4 (UT-209)
    test('UT-209: UserLocationNotifier con sensor GPS apagado en Android retorna null sin bloquear el perfil', () async {
      final fakeRepo = FakeLocationRepository(
        serviceEnabled: false,
        permissionGranted: true,
        mockPosition: createBogotaPosition(),
      );
      final container = ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(userLocationProvider.future);
      expect(result, isNull);
    });

    // 5 (UT-210)
    test('UT-210: UserLocationNotifier.refreshLocation actualiza reactivamente la ubicación cuando el usuario activa el GPS', () async {
      final fakeRepo = FakeLocationRepository(
        serviceEnabled: false,
        permissionGranted: false,
        mockPosition: createBogotaPosition(),
      );
      final container = ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(userLocationProvider.future), isNull);

      fakeRepo.serviceEnabled = true;
      fakeRepo.permissionGranted = true;

      final refreshed = await container.read(userLocationProvider.notifier).refreshLocation();
      expect(refreshed, isNotNull);
      expect(refreshed!.$1.latitude, closeTo(4.7110, 0.0001));
    });
  });
}

