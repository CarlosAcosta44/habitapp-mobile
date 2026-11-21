import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import 'models/user_profile.dart';
import 'models/user_stats.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  Future<UserProfile> getProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener el perfil del usuario');
    }
  }

  Future<UserStats> getUserStats() async {
    try {
      final response = await _dio.get('/users/me/stats');
      return UserStats.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener las estadísticas del usuario');
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/users/me', data: data);
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al actualizar el perfil');
    }
  }
  Future<void> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      await _dio.post('/users/me/avatar', data: formData);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al subir la foto de perfil');
    }
  }

  Future<Map<String, dynamic>?> getMyTrainer() async {
    try {
      final response = await _dio.get('/users/me/trainer');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al consultar entrenador asignado');
    }
  }

  Future<void> linkTrainer(String trainerId) async {
    try {
      await _dio.post('/users/me/trainer/$trainerId');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al vincular con el entrenador');
    }
  }

  Future<void> unlinkTrainer(String trainerId) async {
    try {
      await _dio.delete('/users/me/trainer/$trainerId');
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al desvincular del entrenador');
    }
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ProfileRepository(dio);
}
