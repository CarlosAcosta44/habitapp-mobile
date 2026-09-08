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
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ProfileRepository(dio);
}
