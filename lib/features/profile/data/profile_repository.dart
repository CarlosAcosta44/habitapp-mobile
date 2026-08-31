import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../domain/user_profile.dart';

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
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ProfileRepository(dio);
}
