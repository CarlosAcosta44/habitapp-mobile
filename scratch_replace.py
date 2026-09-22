import re

with open("lib/features/community/providers/community_feed_provider.dart", "r") as f:
    content = f.read()

# Replace the CommunityFeedNotifier class implementation
new_notifier = """class CommunityFeedNotifier extends Notifier<CommunityFeedState> {
  static const int _maxPosts = 12;

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

      final posts = rawForums.map<ForumPostItem>((f) {
        final author = f['usuarios'] != null ? '${f['usuarios']['nombre'] ?? ''} ${f['usuarios']['apellido'] ?? ''}'.trim() : 'Usuario';
        return ForumPostItem(
          id: f['idforo'] ?? '',
          authorName: author.isEmpty ? 'Usuario' : author,
          authorInitials: author.isNotEmpty ? author[0].toUpperCase() : 'U',
          avatarColor: const Color(0xFF2D82FA),
          timeAgo: 'Reciente',
          tag: f['categoria'] != null ? '#${f['categoria']}' : '#Comunidad',
          questionTitle: f['titulo'] ?? '',
          content: f['contenido'] ?? '',
          commentsCount: 0,
          likesCount: 0,
          isLikedByMe: false,
        );
      }).toList();

      final habits = rawHabits.map<CommunityHabitItem>((h) => CommunityHabitItem(
        id: h['idhabito'] ?? '',
        title: h['nombre'] ?? '',
        description: h['descripcion'] ?? '',
        icon: Icons.star_border_rounded,
        iconColor: const Color(0xFFE22D6F),
        iconBgColor: const Color(0xFFFFEBF2),
        participantsCount: 'Hábito comunitario',
      )).toList();

      final articles = rawArts.map<ClinicalArticleItem>((a) => ClinicalArticleItem(
        id: a['idarticulo'] ?? '',
        category: a['categoria']?.toUpperCase() ?? 'SALUD',
        categoryColor: const Color(0xFF0F8A5D),
        readTime: 'Lectura',
        title: a['titulo'] ?? '',
        description: a['contenido'] ?? '',
        author: 'Autor',
        icon: Icons.article_outlined,
        iconColor: const Color(0xFF0F8A5D),
        iconBgColor: const Color(0xFFE6F4EE),
      )).toList();

      final specialists = rawSpecs.map<VerifiedSpecialistItem>((s) => VerifiedSpecialistItem(
        id: s['idusuario'] ?? '',
        name: '${s['nombre'] ?? ''} ${s['apellido'] ?? ''}'.trim(),
        specialty: s['correo'] ?? 'Especialista',
        rating: 5.0,
        reviewsCount: 0,
        priceSession: 'Consultar',
        isOnline: true,
        icon: Icons.psychology_outlined,
        iconColor: const Color(0xFF2D82FA),
        iconBgColor: const Color(0xFFEFF5FF),
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

  void toggleLike(String postId) {}

  void toggleHabitAdded(String habitId) async {
    try {
      await ref.read(communityRepositoryProvider).cloneHabit(habitId);
      final updated = state.habits.map((h) {
        if (h.id == habitId) {
          return h.copyWith(isAdded: true);
        }
        return h;
      }).toList();
      state = state.copyWith(habits: updated);
    } catch (e) {
      // Error cloning
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
}
"""

start_idx = content.find("class CommunityFeedNotifier extends Notifier<CommunityFeedState> {")
end_idx = content.find("final communityFeedProvider =")
if start_idx != -1 and end_idx != -1:
    new_content = content[:start_idx] + new_notifier + content[end_idx:]
    # Also add import for community_repository
    if "import '../data/repositories/community_repository.dart';" not in new_content:
        new_content = new_content.replace("import '../data/models/community_feed_models.dart';", "import '../data/models/community_feed_models.dart';\\nimport '../data/repositories/community_repository.dart';")
    
    with open("lib/features/community/providers/community_feed_provider.dart", "w") as f:
        f.write(new_content)
    print("Replaced successfully")
else:
    print("Could not find blocks")
