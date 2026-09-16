import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/community_feed_models.dart';

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
  static const int _maxPosts = 12; // Límite máximo para simular fin de lista

  @override
  CommunityFeedState build() {
    return CommunityFeedState(
      habits: _initialHabits,
      posts: _generatePostsForPage(1),
      articles: _initialArticles,
      specialists: _initialSpecialists,
      activeChallenge: _initialChallenge,
      currentPage: 1,
      hasMore: true,
      isLoadingMore: false,
    );
  }

  /// Refresca todo el feed (Pull to refresh)
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 700));

    state = state.copyWith(
      isLoading: false,
      currentPage: 1,
      hasMore: true,
      posts: _generatePostsForPage(1),
      habits: _initialHabits,
      activeChallenge: _initialChallenge,
    );
  }

  /// Carga la siguiente página para el Infinite Scroll
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    // Simular latencia de red de 900ms
    await Future.delayed(const Duration(milliseconds: 900));

    final nextPage = state.currentPage + 1;
    final newItems = _generatePostsForPage(nextPage);

    final updatedPosts = [...state.posts, ...newItems];
    final hasMoreData = updatedPosts.length < _maxPosts;

    state = state.copyWith(
      posts: updatedPosts,
      currentPage: nextPage,
      isLoadingMore: false,
      hasMore: hasMoreData,
    );
  }

  /// Filtro superior (Todo, Foros de Apoyo, Hábitos Compartidos, etc.)
  void setFilter(int index) {
    state = state.copyWith(selectedFilterIndex: index);
  }

  /// Búsqueda por texto
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Like / Apoyo en una publicación (Optimistic update)
  void toggleLike(String postId) {
    final updated = state.posts.map((post) {
      if (post.id == postId) {
        final isLiked = post.isLikedByMe;
        return post.copyWith(
          isLikedByMe: !isLiked,
          likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updated);
  }

  /// Toggle añadir hábito comunitario
  void toggleHabitAdded(String habitId) {
    final updated = state.habits.map((h) {
      if (h.id == habitId) {
        return h.copyWith(isAdded: !h.isAdded);
      }
      return h;
    }).toList();

    state = state.copyWith(habits: updated);
  }

  /// Toggle unirse al reto comunitario activo
  void toggleJoinActiveChallenge() {
    state = state.copyWith(
      activeChallenge: state.activeChallenge.copyWith(
        isJoined: !state.activeChallenge.isJoined,
      ),
    );
  }

  // --- Datos iniciales y generador de páginas ---

  static final List<CommunityHabitItem> _initialHabits = [
    const CommunityHabitItem(
      id: 'h-1',
      title: 'Diario de Gratitud 5 min',
      description: 'Anota 3 cosas amables antes de que empiece el día.',
      icon: Icons.menu_book_rounded,
      iconColor: Color(0xFFE22D6F),
      iconBgColor: Color(0xFFFFEBF2),
      participantsCount: '12.4k hacen esto',
      badgeText: 'Popular',
    ),
    const CommunityHabitItem(
      id: 'h-2',
      title: 'Meditación Somática',
      description: 'Escaneo corporal para liberar tensión muscular acumulada.',
      icon: Icons.spa_rounded,
      iconColor: Color(0xFF0F8A5D),
      iconBgColor: Color(0xFFE6F4EE),
      participantsCount: '8.9k hacen esto',
    ),
    const CommunityHabitItem(
      id: 'h-3',
      title: 'Paseo Consciente 15m',
      description: 'Caminar sin celular prestando atención a los sonidos.',
      icon: Icons.directions_walk_rounded,
      iconColor: Color(0xFF2D82FA),
      iconBgColor: Color(0xFFEFF5FF),
      participantsCount: '5.2k hacen esto',
    ),
  ];

  static List<ForumPostItem> _generatePostsForPage(int page) {
    if (page == 1) {
      return [
        const ForumPostItem(
          id: 'p-1',
          authorName: 'Marina López',
          authorInitials: 'ML',
          avatarColor: Color(0xFFE22D6F),
          timeAgo: 'hace 18 min',
          tag: '#Ansiedad',
          questionTitle: '¿Qué hacéis cuando la sensación en el pecho aparece de la nada?',
          content:
              'Llevo 3 días con un nudo constante sin motivo aparente en el trabajo. Busco técnicas de anclaje que os sirvan en el día a día...',
          commentsCount: 34,
          likesCount: 58,
          isLikedByMe: false,
        ),
        const ForumPostItem(
          id: 'p-2',
          authorName: 'Carlos Mendonça',
          authorInitials: 'CM',
          avatarColor: Color(0xFF2D82FA),
          timeAgo: 'hace 1 hora',
          tag: '#Mindfulness',
          questionTitle: 'Mi experiencia superando el insomnio con respiración 4-7-8',
          content:
              'Quería compartir que tras 21 días de práctica continua, reduje el tiempo para dormir de 45 a 10 minutos. ¿Alguien más practica esta técnica?',
          commentsCount: 19,
          likesCount: 42,
          isLikedByMe: true,
        ),
        const ForumPostItem(
          id: 'p-3',
          authorName: 'Lucía Fernández',
          authorInitials: 'LF',
          avatarColor: Color(0xFF0F8A5D),
          timeAgo: 'hace 3 horas',
          tag: '#Motivación',
          questionTitle: '¿Cómo mantener el hábito cuando se tiene un día difícil?',
          content:
              'Hoy casi no completo mi caminata de 15 minutos, pero me recordé la regla de los 2 minutos y logré salir. ¡El secreto es no romper la cadena!',
          commentsCount: 27,
          likesCount: 93,
          isLikedByMe: false,
        ),
      ];
    } else if (page == 2) {
      return [
        const ForumPostItem(
          id: 'p-4',
          authorName: 'David Salcedo',
          authorInitials: 'DS',
          avatarColor: Color(0xFFFF9800),
          timeAgo: 'hace 5 horas',
          tag: '#Hábitos',
          questionTitle: 'Consejo para principiantes en meditación: No busques la mente en blanco',
          content:
              'Muchos abandonan creyendo que meditar es callar el cerebro. En realidad es notar la distracción y volver amablemente a la respiración.',
          commentsCount: 15,
          likesCount: 64,
          isLikedByMe: false,
        ),
        const ForumPostItem(
          id: 'p-5',
          authorName: 'Elena Ramos',
          authorInitials: 'ER',
          avatarColor: Color(0xFF9C27B0),
          timeAgo: 'hace 8 horas',
          tag: '#SaludMental',
          questionTitle: 'Agradecer en momentos de frustración: ¿cómo os ayuda?',
          content:
              'Escribir tres cosas positivas incluso en días pesados me ha ayudado a reconfigurar mi perspectiva. ¿Tenéis un diario de gratitud?',
          commentsCount: 22,
          likesCount: 71,
          isLikedByMe: false,
        ),
        const ForumPostItem(
          id: 'p-6',
          authorName: 'Andrés Gil',
          authorInitials: 'AG',
          avatarColor: Color(0xFF009688),
          timeAgo: 'hace 12 horas',
          tag: '#Productividad',
          questionTitle: 'La técnica Pomodoro adaptada para evitar el agotamiento',
          content:
              'En lugar de 25/5, estoy usando 45/15 con estiramientos guiados en la pausa larga. Mi fatiga visual ha disminuido considerablemente.',
          commentsCount: 11,
          likesCount: 38,
          isLikedByMe: false,
        ),
      ];
    } else {
      return [
        ForumPostItem(
          id: 'p-${page * 3 + 1}',
          authorName: 'Patricia Vélez',
          authorInitials: 'PV',
          avatarColor: const Color(0xFF673AB7),
          timeAgo: 'hace 1 día',
          tag: '#Bienestar',
          questionTitle: 'Celebrar pequeños logros: el impacto de la dopamina natural',
          content:
              'Nos obsesionamos con la meta final y olvidamos celebrar cada día que sí cumplimos el hábito. ¡Cada check cuenta!',
          commentsCount: 8,
          likesCount: 45,
          isLikedByMe: false,
        ),
        ForumPostItem(
          id: 'p-${page * 3 + 2}',
          authorName: 'Gabriel Torres',
          authorInitials: 'GT',
          avatarColor: const Color(0xFF3F51B5),
          timeAgo: 'hace 2 días',
          tag: '#Resiliencia',
          questionTitle: 'Superando el síndrome del impostor en nuevos proyectos',
          content:
              'Comparto este espacio para quienes a veces sienten que no son suficientes. Hablarlo en comunidad alivia la carga.',
          commentsCount: 31,
          likesCount: 110,
          isLikedByMe: false,
        ),
      ];
    }
  }

  static final List<ClinicalArticleItem> _initialArticles = [
    const ClinicalArticleItem(
      id: 'art-1',
      category: 'NEUROCIENCIA',
      categoryColor: Color(0xFF0F8A5D),
      readTime: '5 min de lectura',
      title: 'Cómo gestionar el sobrepensamiento',
      description: 'Técnicas basadas en terapia cognitivo-conductual...',
      author: 'Por Dra. Elena Vidal · Psiquiatra',
      icon: Icons.psychology_outlined,
      iconColor: Color(0xFFE22D6F),
      iconBgColor: Color(0xFFFFEBF2),
    ),
    const ClinicalArticleItem(
      id: 'art-2',
      category: 'FISIOLOGÍA',
      categoryColor: Color(0xFFFF9800),
      readTime: '7 min de lectura',
      title: 'El impacto del sueño en el cortisol',
      description: 'Por qué descansar menos de 7 horas eleva el estrés...',
      author: 'Por Dr. Javier Ruiz · Neurofisiólogo',
      icon: Icons.nightlight_outlined,
      iconColor: Color(0xFF0F8A5D),
      iconBgColor: Color(0xFFE6F4EE),
    ),
  ];

  static final List<VerifiedSpecialistItem> _initialSpecialists = [
    const VerifiedSpecialistItem(
      id: 'spec-1',
      name: 'Lic. Sofía Aranda',
      specialty: 'Psicóloga Clínica · TCC y Trauma',
      rating: 4.9,
      reviewsCount: 65,
      priceSession: '45€ / sesión',
      isOnline: true,
      icon: Icons.assignment_ind_outlined,
      iconColor: Color(0xFF0F8A5D),
      iconBgColor: Color(0xFFE6F4EE),
    ),
    const VerifiedSpecialistItem(
      id: 'spec-2',
      name: 'Dr. Marcos Valiente',
      specialty: 'Mindfulness Terapéutico & Burnout',
      rating: 5.0,
      reviewsCount: 94,
      priceSession: '50€ / sesión',
      isOnline: true,
      icon: Icons.psychology_rounded,
      iconColor: Color(0xFFE22D6F),
      iconBgColor: Color(0xFFFFEBF2),
    ),
  ];

  static const ActiveChallengeSummary _initialChallenge = ActiveChallengeSummary(
    id: 'challenge-1',
    badge: 'Reto Grupal',
    remainingTime: 'Faltan 4 días',
    title: '7 Días de Detox Nocturno',
    participantsInfo: '3,420 participantes activos ahora mismo',
    icon: Icons.nightlight_round,
    isJoined: false,
  );
}

final communityFeedProvider =
    NotifierProvider<CommunityFeedNotifier, CommunityFeedState>(
  CommunityFeedNotifier.new,
);
