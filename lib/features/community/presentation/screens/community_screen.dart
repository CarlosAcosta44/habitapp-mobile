import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/community_feed_models.dart';
import '../../providers/community_feed_provider.dart';
import '../widgets/community_header.dart';
import '../widgets/community_habit_carousel.dart';
import '../widgets/forum_post_card.dart';
import '../widgets/clinical_article_card.dart';
import '../widgets/verified_specialist_card.dart';
import '../widgets/active_challenge_card_compact.dart';
import '../../../profile/providers/profile_provider.dart';
import 'challenges_screen.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);
const _kPink = Color(0xFFE22D6F);

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Detección de proximidad al fondo para disparar el Infinite Scroll
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Disparamos la carga cuando falten 250 píxeles para llegar al final
    if (currentScroll >= maxScroll - 250) {
      ref.read(communityFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityFeedProvider);
    final notifier = ref.read(communityFeedProvider.notifier);
    final profileState = ref.watch(profileProvider);

    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: _kBlue,
          onRefresh: () async {
            await notifier.refresh();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommunityHeader(
                  selectedFilterIndex: state.selectedFilterIndex,
                  onFilterChanged: (index) => notifier.setFilter(index),
                  onSearchChanged: (query) => notifier.setSearchQuery(query),
                  profileImageUrl: profileState.value?.fotoperfil,
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No tienes notificaciones pendientes.')),
                    );
                  },
                  onProfileTap: () => context.push('/profile'),
                ),

                const SizedBox(height: 20),

                // 2. Sección: Hábitos de la comunidad (Visible en Todo o Hábitos Compartidos)
                if (state.selectedFilterIndex == 0 || state.selectedFilterIndex == 2) ...[
                  CommunityHabitCarousel(
                    habits: state.habits,
                    onAddHabit: (id) {
                      notifier.toggleHabitAdded(id);
                      final habit = state.habits.firstWhere((h) => h.id == id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !habit.isAdded
                                ? '¡Hábito "${habit.title}" añadido a tu rutina!'
                                : 'Hábito removido.',
                          ),
                          backgroundColor: !habit.isAdded ? _kGreen : Colors.grey[700],
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    onSeeAll: () {
                      notifier.setFilter(2); // Filtra a hábitos
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                if (state.selectedFilterIndex == 0 || state.selectedFilterIndex == 1) ...[
                  _buildSectionHeader(
                    context,
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: _kPink,
                    iconBgColor: isDark ? _kPink.withValues(alpha: 0.2) : const Color(0xFFFFEBF2),
                    title: 'Foros y Círculos de Apoyo',
                    actionText: 'Ver todos',
                    onAction: () => notifier.setFilter(1),
                  ),
                  const SizedBox(height: 12),

                  // Lista de publicaciones del Feed
                  ...(state.selectedFilterIndex == 0 ? state.posts.take(1) : state.posts).map((post) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ForumPostCard(
                        post: post,
                        onToggleLike: () => notifier.toggleLike(post.id),
                        onParticipate: () {
                          _showParticipateDialog(context, post);
                        },
                      ),
                    );
                  }),

                  // Indicador inferior de Infinite Scroll
                  _buildInfiniteScrollFooter(state),

                  const SizedBox(height: 16),
                ],

                if (state.selectedFilterIndex == 0 || state.selectedFilterIndex == 3) ...[
                  _buildSectionHeader(
                    context,
                    icon: Icons.menu_book_rounded,
                    iconColor: const Color(0xFFC07338),
                    iconBgColor: isDark ? const Color(0xFFC07338).withValues(alpha: 0.2) : const Color(0xFFFFF3E8),
                    title: 'Artículos y Guías Clínicas',
                    actionText: 'Ver biblioteca',
                    onAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abriendo biblioteca de artículos clínicos...')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  ...state.articles.map((article) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClinicalArticleCard(
                        article: article,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Leyendo "${article.title}"')),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                ],

                // 5. Sección: Especialistas Verificados (Visible en Todo o Especialistas)
                if (state.selectedFilterIndex == 0 || state.selectedFilterIndex == 4) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? _kGreen.withValues(alpha: 0.2) : const Color(0xFFE6F4EE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: _kGreen,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Especialistas Verificados',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? _kBlue.withValues(alpha: 0.2) : const Color(0xFFEFF5FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'En línea',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _kBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => notifier.setFilter(4),
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _kGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Terapeutas colegiados con sesiones online confidenciales y personalizadas.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...state.specialists.map((specialist) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: VerifiedSpecialistCard(
                        specialist: specialist,
                        onViewProfile: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Perfil de ${specialist.name}')),
                          );
                        },
                        onBookSession: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Agendando sesión con ${specialist.name} (${specialist.priceSession})'),
                              backgroundColor: _kBlue,
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                ],

                // 6. Sección: Retos Comunitarios Activos (Navega a la pantalla de Retos de Breiner)
                if (state.selectedFilterIndex == 0) ...[
                  _buildSectionHeader(
                    context,
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color(0xFFFF9800),
                    iconBgColor: isDark ? const Color(0xFFFF9800).withValues(alpha: 0.2) : const Color(0xFFFFF3E0),
                    title: 'Retos Comunitarios Activos',
                    actionText: 'Ver todos',
                    onAction: () {
                      notifier.setFilter(5); // Cambiar a la pestaña Retos
                    },
                  ),
                  const SizedBox(height: 12),

                  ActiveChallengeCardCompact(
                    challenge: state.activeChallenge,
                    onJoin: () {
                      notifier.toggleJoinActiveChallenge();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !state.activeChallenge.isJoined
                                ? '¡Te uniste a "${state.activeChallenge.title}"!'
                                : 'Has salido del reto.',
                          ),
                          backgroundColor: !state.activeChallenge.isJoined ? _kGreen : colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                    onSeeAll: () {
                      notifier.setFilter(5); // Cambiar a la pestaña Retos
                    },
                  ),

                  const SizedBox(height: 40),
                ],

                // 7. Pestaña de Retos Completa (Visible solo en índice 5)
                if (state.selectedFilterIndex == 5) ...[
                  const ChallengesView(),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Encabezado reutilizable de cada sección
  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _kGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfiniteScrollFooter(CommunityFeedState state) {
    final theme = Theme.of(context);
    
    if (state.isLoadingMore) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _kBlue,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Cargando más publicaciones...',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (!state.hasMore) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: Text(
          '✨ ¡Estás al día con todas las publicaciones!',
          style: TextStyle(
            fontSize: 11.5,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Diálogo para responder a una publicación
  void _showParticipateDialog(BuildContext context, ForumPostItem post) {
    final textController = TextEditingController();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Responder a ${post.authorName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post.questionTitle,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: textController,
                maxLines: 4,
                autofocus: true,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta o técnica de apoyo...',
                  hintStyle: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark 
                      ? colorScheme.surfaceContainerHighest 
                      : const Color(0xFFF7F7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final text = textController.text.trim();
                    if (text.isNotEmpty) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Tu respuesta fue publicada en el foro!'),
                          backgroundColor: _kGreen,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Publicar respuesta',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
