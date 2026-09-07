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

  Future<Map<String, dynamic>> register(String email, String password, String nombre, String apellido) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'nombre': nombre,
          'apellido': apellido,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al registrarse');
    }
  }

  // --- SOCIAL LOGIN ---

  Future<String> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post('/auth/google/token', data: {
        'token': idToken,
      });
      // El backend devuelve { "access_token": "..." } y setea el refresh_token en cookie
      return response.data['access_token'] as String;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al iniciar sesión con Google');
    }
  }

  Future<String> loginWithApple(String identityToken) async {
    try {
      final response = await _dio.post('/auth/apple/token', data: {
        'token': identityToken,
      });
      return response.data['access_token'] as String;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al iniciar sesión con Apple');
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepository(dio);
}
