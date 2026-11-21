import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../models/friend_model.dart';

class FriendsRepository {
  final Dio _dio;

  FriendsRepository(this._dio);

  Future<List<FriendModel>> getFriends() async {
    try {
      final response = await _dio.get('/users/friends');
      final data = response.data as List;
      return data.map((json) => FriendModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener amigos');
    }
  }

  Future<void> addFriend(String idAmigo) async {
    try {
      await _dio.post('/users/friends', data: {'targetUserId': idAmigo});
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al agregar amigo');
    }
  }

  Future<List<FriendModel>> getSuggestions({int limit = 12}) async {
    try {
      final response = await _dio.get('/users/friends/suggestions?limit=$limit');
      final data = response.data as List;
      return data.map((json) => FriendModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener sugerencias de amigos');
    }
  }

  Future<void> removeFriend(String idAmigo) async {
    try {
      await _dio.delete('/users/friends/$idAmigo');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar amigo');
    }
  }
}

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return FriendsRepository(dio);
});
