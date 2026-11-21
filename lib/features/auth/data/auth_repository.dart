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

  Future<Map<String, dynamic>> register(String email, String password, String nombre, String apellido, {String? genero, String? fechanacimiento}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
        'nombre': nombre,
        'apellido': apellido,
      };
      if (genero != null) data['genero'] = genero;
      if (fechanacimiento != null) data['fechanacimiento'] = fechanacimiento;

      final response = await _dio.post(
        '/auth/register',
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al registrarse');
    }
  }

  // --- SOCIAL LOGIN ---

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await _dio.post('/auth/google', data: {
        'idToken': idToken,
      });
      // El backend devuelve { "access_token": "...", "refresh_token": "..." }
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al iniciar sesión con Google');
    }
  }

  Future<void> linkWithGoogle(String idToken) async {
    try {
      await _dio.post('/auth/google', data: {
        'idToken': idToken,
      });
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al vincular con Google');
    }
  }

  Future<Map<String, dynamic>> loginWithFacebook(String accessToken) async {
    try {
      final response = await _dio.post('/auth/facebook', data: {
        'accessToken': accessToken,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al iniciar sesión con Facebook');
    }
  }

  Future<void> linkWithFacebook(String accessToken) async {
    try {
      await _dio.post('/auth/facebook', data: {
        'accessToken': accessToken,
      });
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al vincular con Facebook');
    }
  }

  Future<Map<String, dynamic>> loginWithApple(String identityToken) async {
    try {
      final response = await _dio.post('/auth/apple/token', data: {
        'token': identityToken,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al iniciar sesión con Apple');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al solicitar recuperación de contraseña');
    }
  }

  Future<void> updatePassword(String newPassword, {String? token}) async {
    try {
      await _dio.put(
        '/auth/update-password',
        data: {
          'token': ?token,
          'newPassword': newPassword,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar contraseña');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } on DioException {
      // Limpieza local continúa aunque el token ya haya expirado en servidor
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepository(dio);
}
