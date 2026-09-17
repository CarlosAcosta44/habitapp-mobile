import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/dio_client.dart';
import '../data/biometric_repository.dart';

part 'biometric_provider.g.dart';

class BiometricState {
  final bool isEnabled; // Is biometric authentication enabled by the user in settings
  final bool isLocked;  // Is the app currently locked and awaiting biometric auth

  BiometricState({required this.isEnabled, required this.isLocked});
}

@Riverpod(keepAlive: true)
class BiometricNotifier extends _$BiometricNotifier {
  late FlutterSecureStorage _storage;
  late BiometricRepository _repository;

  @override
  Future<BiometricState> build() async {
    _storage = ref.watch(secureStorageProvider);
    _repository = ref.watch(biometricRepositoryProvider);

    final enabledStr = await _storage.read(key: 'biometric_enabled');
    final isEnabled = enabledStr == 'true';
    
    // If it's enabled, the app starts locked.
    return BiometricState(isEnabled: isEnabled, isLocked: isEnabled);
  }

  Future<void> toggleBiometric(bool enable) async {
    if (enable) {
      final isAvailable = await _repository.isBiometricAvailable();
      if (!isAvailable) {
        throw Exception('Tu dispositivo no soporta biometría.');
      }
      // Prompt user to authenticate before enabling
      final success = await _repository.authenticate();
      if (!success) return;
    }
    
    await _storage.write(key: 'biometric_enabled', value: enable ? 'true' : 'false');
    state = AsyncValue.data(BiometricState(isEnabled: enable, isLocked: false));
  }

  Future<bool> unlock() async {
    final success = await _repository.authenticate();
    if (success && state.value != null) {
      state = AsyncValue.data(
        BiometricState(isEnabled: state.value!.isEnabled, isLocked: false),
      );
    }
    return success;
  }
}
