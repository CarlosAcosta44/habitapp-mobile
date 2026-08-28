import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late FlutterSecureStorage _storage;
  late AuthRepository _repository;

  @override
  Future<bool> build() async {
    _storage = ref.watch(secureStorageProvider);
    _repository = ref.watch(authRepositoryProvider);
    return _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.login(email, password);
      final token = response['access_token'];
      if (token != null) {
        await _storage.write(key: 'access_token', value: token);
        state = const AsyncValue.data(true);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.register(email, password);
      final token = response['access_token'];
      if (token != null) {
        await _storage.write(key: 'access_token', value: token);
        state = const AsyncValue.data(true);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    state = const AsyncValue.data(false);
  }
}
