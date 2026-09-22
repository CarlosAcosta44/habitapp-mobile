import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/community_repository.dart';

part 'community_provider.g.dart';

// ================= Foros =================
@riverpod
class ForumsNotifier extends _$ForumsNotifier {
  @override
  FutureOr<List<dynamic>> build() async {
    return _fetchForums();
  }

  Future<List<dynamic>> _fetchForums() async {
    final repository = ref.read(communityRepositoryProvider);
    return await repository.getForums();
  }

  Future<void> refreshForums() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchForums());
  }
  Future<void> toggleLike(String forumId) async {
    // Optimistic update
    if (state.value != null) {
      final forums = List<dynamic>.from(state.value!);
      final idx = forums.indexWhere((f) => f['idforo'] == forumId);
      if (idx != -1) {
        final f = Map<String, dynamic>.from(forums[idx]);
        f['liked_by_me'] = !(f['liked_by_me'] == true);
        f['likes_count'] = (f['likes_count'] ?? 0) + (f['liked_by_me'] ? 1 : -1);
        forums[idx] = f;
        state = AsyncValue.data(forums);
      }
    }
    // API call — do NOT set state in catch to avoid dispose errors.
    // The optimistic update is kept regardless.
    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.addReaction('foro', forumId, 'LIKE');
    } catch (_) {
      // Revert only if provider is not disposed
      try {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchForums());
      } catch (e) {
        // Ignore error if disposed
      }
    }
  }

  Future<void> deleteForum(String forumId) async {
    // Actually we will just call the repo and refresh
    final repository = ref.read(communityRepositoryProvider);
    await repository.deleteForum(forumId); // Ensure you have this
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchForums());
  }
}

@riverpod
class ForumCommentsNotifier extends _$ForumCommentsNotifier {
  @override
  FutureOr<List<dynamic>> build(String forumId) async {
    return _fetchComments(forumId);
  }

  Future<List<dynamic>> _fetchComments(String id) async {
    final repository = ref.read(communityRepositoryProvider);
    return await repository.getComments(id);
  }

  Future<void> addComment(String forumId, String contenido, {String? parentId, String? imagenUrl}) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.addComment(forumId, contenido, parentId: parentId, imagenUrl: imagenUrl);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchComments(forumId));
  }

  Future<String> uploadImage(String path) async {
    final repository = ref.read(communityRepositoryProvider);
    return await repository.uploadImage(path);
  }

  Future<void> deleteComment(String forumId, String commentId) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.deleteComment(commentId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchComments(forumId));
  }

  Future<void> toggleLike(String forumId, String commentId) async {
    // Optimistic update
    if (state.value != null) {
      final comments = List<dynamic>.from(state.value!);
      final idx = comments.indexWhere((c) => c['idcomentario'] == commentId);
      if (idx != -1) {
        final c = Map<String, dynamic>.from(comments[idx]);
        c['liked_by_me'] = !(c['liked_by_me'] == true);
        c['likes_count'] = (c['likes_count'] ?? 0) + (c['liked_by_me'] ? 1 : -1);
        comments[idx] = c;
        state = AsyncValue.data(comments);
      }
    }
    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.addReaction('comentario', commentId, 'LIKE');
    } catch (_) {
      try {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => _fetchComments(forumId));
      } catch (e) {
        // Ignore error if disposed
      }
    }
  }
}

// ================= Retos =================
@riverpod
class RetosNotifier extends _$RetosNotifier {
  @override
  FutureOr<List<dynamic>> build() async {
    return _fetchRetos();
  }

  Future<List<dynamic>> _fetchRetos() async {
    final repository = ref.read(communityRepositoryProvider);
    return await repository.getRetos();
  }

  Future<void> joinReto(String retoId) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.joinReto(retoId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRetos());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRetos());
  }
}

// ================= Especialistas =================
@riverpod
Future<List<dynamic>> especialistas(Ref ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  return await repository.getEspecialistas();
}

// ================= Artículos =================
@riverpod
Future<List<dynamic>> articulos(Ref ref) async {
  final repository = ref.watch(communityRepositoryProvider);
  return await repository.getArticulos();
}

// ================= Hábitos Comunitarios =================
@riverpod
class CommunityHabitsNotifier extends _$CommunityHabitsNotifier {
  @override
  FutureOr<List<dynamic>> build() async {
    return _fetchHabits();
  }

  Future<List<dynamic>> _fetchHabits() async {
    final repository = ref.read(communityRepositoryProvider);
    return await repository.getCommunityHabits();
  }

  Future<void> cloneHabit(String idhabito) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.cloneHabit(idhabito);
  }

  Future<void> shareHabit(String habitId) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.shareHabit(habitId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchHabits());
  }
}

// ================= Reacciones =================
@riverpod
class ReactionNotifier extends _$ReactionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> addReaction(String targetType, String targetId, String tipo) async {
    final repository = ref.read(communityRepositoryProvider);
    await repository.addReaction(targetType, targetId, tipo);
  }
}
