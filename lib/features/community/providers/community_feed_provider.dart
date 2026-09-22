import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/community_feed_models.dart';
import '../data/repositories/community_repository.dart';
import '../../habits/data/models/category_model.dart';
import '../../habits/providers/habits_provider.dart';
import '../../profile/providers/profile_provider.dart';

class CommunityFeedState {
  final List<CommunityHabitItem> habits;
  final List<ForumPostItem> posts;
  final List<ClinicalArticleItem> articles;
  final List<VerifiedSpecialistItem> specialists;
  final ActiveChallengeSummary activeChallenge;
  final int selectedFilterIndex;
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;

  const CommunityFeedState({
    required this.habits,
    required this.posts,
    required this.articles,
    required this.specialists,
    required this.activeChallenge,
    this.selectedFilterIndex = 0,
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  CommunityFeedState copyWith({
    List<CommunityHabitItem>? habits,
    List<ForumPostItem>? posts,
    List<ClinicalArticleItem>? articles,
    List<VerifiedSpecialistItem>? specialists,
    ActiveChallengeSummary? activeChallenge,
    int? selectedFilterIndex,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
  }) {
    return CommunityFeedState(
      habits: habits ?? this.habits,
      posts: posts ?? this.posts,
      articles: articles ?? this.articles,
      specialists: specialists ?? this.specialists,
      activeChallenge: activeChallenge ?? this.activeChallenge,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class CommunityFeedNotifier extends Notifier<CommunityFeedState> {
  @override
  CommunityFeedState build() {
    Future.microtask(() => _fetchInitialData());
    return const CommunityFeedState(
      habits: [],
      posts: [],
      articles: [],
      specialists: [],
      activeChallenge: ActiveChallengeSummary(
        id: '1',
        badge: 'Retos',
        remainingTime: '',
        title: 'Cargando retos...',
        participantsInfo: '',
        icon: Icons.nightlight_round,
        isJoined: false,
      ),
      currentPage: 1,
      hasMore: false,
      isLoading: true,
    );
  }

  Future<void> _fetchInitialData() async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      
      final rawForums = await repo.getForums();
      final rawHabits = await repo.getCommunityHabits();
      final rawRetos = await repo.getRetos();
      final rawArts = await repo.getArticulos();
      final rawSpecs = await repo.getEspecialistas();

      final myId = ref.read(profileProvider).value?.idusuario;
      final myHabits = ref.read(habitsDashboardProvider).value ?? [];

      final posts = rawForums.map<ForumPostItem>((f) {
        final author = f['usuarios'] != null ? '${f['usuarios']['nombre'] ?? ''} ${f['usuarios']['apellido'] ?? ''}'.trim() : 'Usuario';
        return ForumPostItem(
          id: f['idforo'] ?? '',
          authorId: f['idusuario'] ?? '',
          authorName: author.isEmpty ? 'Usuario' : author,
          authorInitials: author.isNotEmpty ? author[0].toUpperCase() : 'U',
          authorAvatarUrl: f['usuarios']?['fotoperfil'] ?? '',
          avatarColor: const Color(0xFF2D82FA),
          timeAgo: 'Reciente',
          fechacreacion: f['fechacreacion'],
          tag: f['categoria'] != null ? '#${f['categoria']}' : '#Comunidad',
          questionTitle: f['titulo'] ?? '',
          content: f['contenido'] ?? '',
          commentsCount: f['comments_count'] ?? 0,
          likesCount: f['likes_count'] ?? 0,
          isLikedByMe: f['liked_by_me'] ?? false,
        );
      }).toList();

      final habits = rawHabits.map<CommunityHabitItem>((h) {
        final catName = h['categoria_nombre'] ?? 'General';
        final catModel = CategoryModel(id: '', nombre: catName);

        final habitUserId = h['idusuario'] ?? '';
        final isMine = myId != null && habitUserId == myId;
        final alreadyInDashboard = myHabits.any((mh) => mh.nombre == h['nombre']);

        return CommunityHabitItem(
          id: h['idhabito'] ?? '',
          title: h['nombre'] ?? '',
          description: h['descripcion'] ?? '',
          icon: catModel.parsedIcon,
          iconColor: catModel.parsedColor,
          iconBgColor: catModel.parsedColor.withValues(alpha: 0.15),
          participantsCount: '${h['clones_count'] ?? 0} lo practican',
          badgeText: catName,
          isAdded: alreadyInDashboard,
          userId: habitUserId,
          isMine: isMine,
        );
      }).toList();

      final articles = rawArts.map<ClinicalArticleItem>((a) => ClinicalArticleItem(
        id: a['idarticulo'] ?? '',
        category: a['categoria']?.toUpperCase() ?? 'SALUD',
        categoryColor: const Color(0xFF0F8A5D),
        readTime: 'Lectura',
        title: a['titulo'] ?? '',
        description: a['contenido'] ?? '',
        publishDate: a['fechapublicacion'] != null ? a['fechapublicacion'].toString().substring(0, 10) : 'Reciente',
        content: a['contenido'] ?? '',
      )).toList();

      final specialists = rawSpecs.map<VerifiedSpecialistItem>((s) => VerifiedSpecialistItem(
        id: s['idusuario'] ?? '',
        name: '${s['nombre'] ?? ''} ${s['apellido'] ?? ''}'.trim(),
        specialty: s['especialidad'] ?? 'Entrenador',
        avatarUrl: s['fotoperfil'] ?? '',
      )).toList();

      ActiveChallengeSummary activeChallenge = const ActiveChallengeSummary(
        id: '0',
        badge: 'Retos',
        remainingTime: '',
        title: 'Sin retos activos',
        participantsInfo: '',
        icon: Icons.nightlight_round,
        isJoined: false,
      );

      if (rawRetos.isNotEmpty) {
        final r = rawRetos.first;
        activeChallenge = ActiveChallengeSummary(
          id: r['idreto'] ?? '',
          badge: 'Reto',
          remainingTime: r['fechafin'] != null ? 'Hasta ${r['fechafin'].toString().substring(0,10)}' : '',
          title: r['titulo'] ?? '',
          participantsInfo: r['descripcion'] ?? '',
          icon: Icons.flag,
          isJoined: false,
        );
      }

      state = state.copyWith(
        isLoading: false,
        posts: posts,
        habits: habits,
        articles: articles,
        specialists: specialists,
        activeChallenge: activeChallenge,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _fetchInitialData();
  }

  Future<void> loadMore() async {}

  void setFilter(int index) {
    state = state.copyWith(selectedFilterIndex: index);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> toggleLike(String postId) async {
    try {
      // Optimistic UI update
      final updated = state.posts.map((p) {
        if (p.id == postId) {
          final isLiked = !p.isLikedByMe;
          return p.copyWith(
            isLikedByMe: isLiked,
            likesCount: p.likesCount + (isLiked ? 1 : -1),
          );
        }
        return p;
      }).toList();
      state = state.copyWith(posts: updated);

      await ref.read(communityRepositoryProvider).addReaction('foro', postId, 'LIKE');
    } catch (e) {
      // Rollback on error
      await _fetchInitialData();
    }
  }

  Future<void> toggleHabitAdded(String habitId) async {
    try {
      await ref.read(communityRepositoryProvider).cloneHabit(habitId);
      final updated = state.habits.map((h) {
        if (h.id == habitId) {
          return h.copyWith(isAdded: true);
        }
        return h;
      }).toList();
      state = state.copyWith(habits: updated);
      
      // Actualizar el dashboard
      ref.read(habitsDashboardProvider.notifier).refresh();
    } catch (e) {
      // Error cloning
      throw Exception('Error al clonar el hábito');
    }
  }

  Future<void> deleteSharedHabit(String habitId) async {
    try {
      await ref.read(communityRepositoryProvider).deleteSharedHabit(habitId);
      final updated = state.habits.where((h) => h.id != habitId).toList();
      state = state.copyWith(habits: updated);
    } catch (e) {
      throw Exception('Error al eliminar el hábito compartido');
    }
  }

  void toggleJoinActiveChallenge() async {
    try {
      if (!state.activeChallenge.isJoined) {
        await ref.read(communityRepositoryProvider).joinReto(state.activeChallenge.id);
        state = state.copyWith(
          activeChallenge: state.activeChallenge.copyWith(isJoined: true),
        );
      }
    } catch (e) {
      // Error
    }
  }

  Future<void> createForum(String titulo, String descripcion, String categoria) async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.createForum(titulo, descripcion, categoria);
      await _fetchInitialData();
    } catch (e) {
      throw Exception('Error al crear foro: $e');
    }
  }

  Future<void> updateForum(String id, {String? titulo, String? descripcion, String? categoria}) async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.updateForum(id, titulo: titulo, descripcion: descripcion, categoria: categoria);
      await _fetchInitialData();
    } catch (e) {
      throw Exception('Error al actualizar foro: $e');
    }
  }

  Future<void> deleteForum(String id) async {
    try {
      final repo = ref.read(communityRepositoryProvider);
      await repo.deleteForum(id);
      await _fetchInitialData();
    } catch (e) {
      throw Exception('Error al eliminar foro: $e');
    }
  }
}
final communityFeedProvider =
    NotifierProvider<CommunityFeedNotifier, CommunityFeedState>(
  CommunityFeedNotifier.new,
);
