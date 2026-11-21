import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habitapp_frontend/core/network/dio_client.dart';
import 'package:habitapp_frontend/features/auth/data/biometric_repository.dart';
import 'package:habitapp_frontend/features/auth/providers/biometric_provider.dart';

class FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> store = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) store[key] = value;
  }
}

class FakeBiometricRepository extends Fake implements BiometricRepository {
  bool available;
  bool authResult;

  FakeBiometricRepository({this.available = true, this.authResult = true});

  @override
  Future<bool> isBiometricAvailable() async => available;

  @override
  Future<bool> authenticate() async => authResult;
}

void main() {
  group('BiometricRepository y BiometricProvider — Tabla de decisión 9 (UT-201 a UT-205)', () {
    // 1 (UT-201)
    test('UT-201: TD9-R4 Biometría desactivada en Ajustes inicia con isEnabled=false e isLocked=false (US042)', () async {
      final storage = FakeSecureStorage();
      final repo = FakeBiometricRepository();
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          biometricRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(biometricProvider.future);
      expect(state.isEnabled, isFalse);
      expect(state.isLocked, isFalse);
    });

    // 2 (UT-202)
    test('UT-202: Biometría previamente activada inicia con la aplicación bloqueada (isEnabled=true, isLocked=true)', () async {
      final storage = FakeSecureStorage()..store['biometric_enabled'] = 'true';
      final repo = FakeBiometricRepository();
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          biometricRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(biometricProvider.future);
      expect(state.isEnabled, isTrue);
      expect(state.isLocked, isTrue);
    });

    // 3 (UT-203)
    test('UT-203: TD9-R1 unlock con huella digital o respaldo del SO válido desbloquea al instante (isLocked=false)', () async {
      final storage = FakeSecureStorage()..store['biometric_enabled'] = 'true';
      final repo = FakeBiometricRepository(available: true, authResult: true);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          biometricRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(biometricProvider.future);
      final unlocked = await container.read(biometricProvider.notifier).unlock();
      final afterState = await container.read(biometricProvider.future);

      expect(unlocked, isTrue);
      expect(afterState.isLocked, isFalse);
    });

    // 4 (UT-204)
    test('UT-204: TD9-R2 unlock con huella fallida o cancelación mantiene la aplicación bloqueada (isLocked=true)', () async {
      final storage = FakeSecureStorage()..store['biometric_enabled'] = 'true';
      final repo = FakeBiometricRepository(available: true, authResult: false);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          biometricRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(biometricProvider.future);
      final unlocked = await container.read(biometricProvider.notifier).unlock();
      final afterState = await container.read(biometricProvider.future);

      expect(unlocked, isFalse);
      expect(afterState.isLocked, isTrue);
    });

    // 5 (UT-205)
    test('UT-205: TD9-R3 toggleBiometric(true) en dispositivo sin hardware compatible lanza excepción informativa', () async {
      final storage = FakeSecureStorage();
      final repo = FakeBiometricRepository(available: false, authResult: false);
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          biometricRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(biometricProvider.future);
      expect(
        () => container.read(biometricProvider.notifier).toggleBiometric(true),
        throwsException,
      );
    });
  });
}
