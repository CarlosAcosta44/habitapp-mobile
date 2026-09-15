import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/post.dart';
import '../domain/challenge.dart';

part 'community_repository.g.dart';

class CommunityRepository {
  final Dio _dio;

  CommunityRepository(this._dio);

  Future<List<Post>> getFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/community/posts',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load community feed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Network error loading feed: ${e.message}');
    }
  }

  Future<void> toggleLike(String postId) async {
    try {
      await _dio.post('/community/posts/$postId/like');
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  Future<List<Challenge>> getChallenges() async {
    try {
      final response = await _dio.get('/community/challenges');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data
            .map((json) => Challenge.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to load challenges');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Network error loading challenges: ${e.message}');
    }
  }

  Future<void> joinChallenge(String challengeId) async {
    try {
      await _dio.post('/community/challenges/$challengeId/join');
    } catch (e) {
      throw Exception('Failed to join challenge: $e');
    }
  }
}

@riverpod
CommunityRepository communityRepository(Ref ref) {
  return CommunityRepository(ref.watch(dioClientProvider));
}
