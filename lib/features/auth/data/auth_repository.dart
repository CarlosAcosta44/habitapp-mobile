import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data; // Expected: { "access_token": "...", "user": {...} }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al iniciar sesión');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al registrarse');
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepository(dio);
}
