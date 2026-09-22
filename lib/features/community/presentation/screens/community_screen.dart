import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/community_feed_provider.dart';
import '../widgets/clinical_article_card.dart';
import '../widgets/community_habits_tab.dart';
import '../widgets/community_header.dart';
import '../widgets/create_forum_dialog.dart';
import '../widgets/forum_post_card.dart';
import '../widgets/verified_specialist_card.dart';
import '../../../profile/providers/profile_provider.dart';
import 'challenges_screen.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);

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

                // 2. Sección: Hábitos de la comunidad
                if (state.selectedFilterIndex == 1) ...[
                  CommunityHabitsTab(
                    habits: state.habits,
                    onAddHabit: (id) async {
                      final habit = state.habits.firstWhere((h) => h.id == id);
                      if (habit.isAdded) return; // Ya está añadido

                      try {
                        await notifier.toggleHabitAdded(id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('¡Hábito "${habit.title}" añadido a tu rutina!'),
                            backgroundColor: _kGreen,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No se pudo añadir el hábito: ${e.toString().replaceAll('Exception: ', '')}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    onDeleteHabit: (id) async {
                      try {
                        await notifier.deleteSharedHabit(id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hábito eliminado de la comunidad.'),
                            backgroundColor: _kGreen,
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al eliminar: ${e.toString().replaceAll('Exception: ', '')}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                if (state.selectedFilterIndex == 0) ...[
                    // Nuevo Hilo Banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF6B4EFF), size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('¿Quieres iniciar una conversación?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    SizedBox(height: 2),
                                    Text('Crea un foro y conecta con la comunidad', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const CreateForumDialog(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B4EFF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, size: 16),
                                SizedBox(width: 4),
                                Text('Crear foro', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),


                  _buildSectionHeader(
                    context,
                    title: 'Foros de la Comunidad',
                  ),
                  const SizedBox(height: 12),

                  // Active Posts
                  ...state.posts.map((post) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ForumPostCard(
                        post: post,
                        currentUserId: profileState.value?.idusuario,
                        onToggleLike: () => notifier.toggleLike(post.id),
                        onParticipate: () {
                          context.push('/community/forum/${post.id}', extra: post.questionTitle);
                        },
                        onEdit: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('La edición estará disponible pronto.')),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Eliminar Foro'),
                              content: const Text('¿Estás seguro de eliminar este foro? Esta acción no se puede deshacer.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
                                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await notifier.deleteForum(post.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foro eliminado')));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            }
                          }
                        },
                      ),
                    );
                  }),

                  // Indicador inferior de Infinite Scroll
                  _buildInfiniteScrollFooter(state),

                  const SizedBox(height: 16),
                ],

                if (state.selectedFilterIndex == 2) ...[
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
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.85,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${article.category} • ${article.readTime}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: article.categoryColor,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    article.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=HabitApp&background=0D8ABC&color=fff'),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'HabitApp • Publicado el ${article.publishDate}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        article.content,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                ],

                // 5. Sección: Especialistas Verificados
                if (state.selectedFilterIndex == 3) ...[
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
                        ],
                      ),
                      GestureDetector(
                        onTap: () => notifier.setFilter(3),
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
                            const SnackBar(content: Text('Funcionalidad no disponible')),
                          );
                        },
                        onBookSession: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Funcionalidad no disponible')),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                ],

                // 7. Pestaña de Retos Completa
                if (state.selectedFilterIndex == 4) ...[
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
    required String title,
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor ?? Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor ?? Colors.black, size: 18),
              ),
            if (icon != null) const SizedBox(width: 8),
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
        if (actionText != null)
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

}
