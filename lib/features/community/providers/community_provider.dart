import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/community_repository.dart';
import '../data/models/post.dart';

part 'community_provider.g.dart';

@riverpod
class FeedNotifier extends _$FeedNotifier {
  int _page = 1;
  bool _hasMore = true;

  @override
  FutureOr<List<Post>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchPage(1);
  }

  Future<List<Post>> _fetchPage(int page) async {
    final repository = ref.read(communityRepositoryProvider);
    final posts = await repository.getFeed(page: page, limit: 10);
    if (posts.length < 10) {
      _hasMore = false;
    }
    return posts;
  }

  bool _isFetchingMore = false;

  Future<void> loadMore() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;

    try {
      final newPosts = await _fetchPage(_page + 1);
      _page++;
      state = AsyncData([...(state.value ?? []), ...newPosts]);
    } catch (e) {
      // Ignoramos el error para no perder la lista actual en la UI,
      // o podríamos usar un estado personalizado.
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> toggleLike(String postId) async {
    // Optimistic update
    final previousState = state;

    if (state.value != null) {
      final updatedPosts = state.value!.map((post) {
        if (post.id == postId) {
          final isLiked = post.isLikedByMe;
          return post.copyWith(
            isLikedByMe: !isLiked,
            likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
          );
        }
        return post;
      }).toList();

      state = AsyncData(updatedPosts);
    }

    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.toggleLike(postId);
    } catch (e) {
      // Revert on failure
      state = previousState;
    }
  }
}
