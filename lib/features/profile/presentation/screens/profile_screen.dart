import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../providers/friends_provider.dart';
import '../../../location/presentation/widgets/location_card.dart';

const _kPurple = Color(0xFF6B48FF);
const _kOrange = Color(0xFFFF7A59);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final friendsState = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No se pudo cargar el perfil'));
          }

          return CustomScrollView(
            slivers: [
              // ── AppBar ──
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Center(
                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                title: Text(
                  'Mi Perfil',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                centerTitle: true,
                actions: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05), shape: BoxShape.circle),
                    child: GestureDetector(
                      onTap: () => context.push('/settings'),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.tune, color: Theme.of(context).colorScheme.onSurface, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── User Card ──
                    _buildUserCard(context, profile, ref),
                    const SizedBox(height: 16),

                    // ── Ubicación GPS ──
                    const LocationCard(),
                    const SizedBox(height: 24),

                    // ── Basic Stats Row ──
                    _buildBasicStatsRow(context, ref),
                    const SizedBox(height: 24),

                    // ── Puntos de Bienestar ──
                    _buildSectionHeader(context, 'Puntos de Bienestar', badgeText: '+320 pts esta semana', icon: Icons.stars, iconColor: _kPurple),
                    const SizedBox(height: 12),
                    _buildPointsCard(context, profile),
                    const SizedBox(height: 32),

                    // ── Logros ──
                    _buildSectionHeader(context, 'Logros', subtitle: '12 de 24', actionText: 'Ver todos ->', icon: Icons.workspace_premium, iconColor: _kPurple),
                    const SizedBox(height: 16),
                    _buildAchievementsRow(context),
                    const SizedBox(height: 32),

                    // ── Amigos ──
                    _buildSectionHeader(context, 'Amigos', subtitle: '18 amigos', actionText: '+ Añadir amigos', icon: Icons.people_alt_outlined, iconColor: _kPurple),
                    const SizedBox(height: 16),
                    
                    // Lista de amigos desde el backend
                    friendsState.when(
                      data: (friends) {
                        if (friends.isEmpty) {
                          return Center(child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Aún no tienes amigos añadidos.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ));
                        }
                        return Column(
                          children: friends.map((friend) => _buildFriendTile(
                            context,
                            name: '${friend.nombre} ${friend.apellido}',
                            streak: '${friend.rachaDias} días',
                            subtitle: 'En racha hoy', // Mocked subtitle
                            avatarUrl: friend.fotoperfil,
                            actionType: 'Saludar',
                          )).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => const Center(child: Text('Error al cargar amigos')),
                    ),

                    const SizedBox(height: 16),

                    // ── Botón Buscar Contactos ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.contact_page_outlined, size: 18, color: Theme.of(context).colorScheme.onSurface),
                          const SizedBox(width: 8),
                          Text('Buscar amigos por contacto o enlace compartido', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  Widgets
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildUserCard(BuildContext context, profile, WidgetRef ref) {
    final statsAsync = ref.watch(profileStatsProvider);
    
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              Text('${profile.nombre} ${profile.apellido}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text(profile.correo ?? '', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.self_improvement, color: _kPurple, size: 14),
                        const SizedBox(width: 6),
                        Text(profile.nombrerol, style: const TextStyle(color: _kPurple, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: _kOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: _kOrange, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          statsAsync.when(
                            data: (s) => '${s.rachaActual} días de racha',
                            loading: () => 'Cargando...',
                            error: (e, st) => 'Error',
                          ), 
                          style: const TextStyle(color: _kOrange, fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/profile/edit'),
                  icon: const Icon(Icons.edit, size: 16, color: _kPurple),
                  label: const Text('Editar Perfil', style: TextStyle(color: _kPurple, fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Avatar sobrepuesto
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
                boxShadow: [BoxShadow(color: _kPurple.withValues(alpha: 0.2), blurRadius: 16, spreadRadius: 4)],
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                backgroundImage: profile.fotoperfil != null ? NetworkImage(profile.fotoperfil!) : null,
                child: profile.fotoperfil == null ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 40) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicStatsRow(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(profileStatsProvider);
    
    return Row(
      children: [
        _buildStatBox(
          context,
          statsAsync.when(data: (s) => s.activeHabitsCount.toString(), loading: () => '-', error: (e, st) => '!'),
          'Hábitos\nactivos'
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          context,
          statsAsync.when(data: (s) => '${s.tasaExito}%', loading: () => '-', error: (e, st) => '!'),
          'Tasa de\néxito'
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          context,
          statsAsync.when(data: (s) => s.diasTotales.toString(), loading: () => '-', error: (e, st) => '!'),
          'Veces\ncompletadas'
        ),
      ],
    );
  }

  Widget _buildStatBox(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kPurple)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {String? subtitle, String? actionText, required IconData icon, required Color iconColor, String? badgeText}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
        if (badgeText != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(badgeText, style: const TextStyle(fontSize: 10, color: _kPurple, fontWeight: FontWeight.bold)),
          ),
        ],
        const Spacer(),
        if (actionText != null)
          Text(actionText, style: const TextStyle(fontSize: 12, color: _kPurple, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPointsCard(BuildContext context, dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_kPurple, Color(0xFF8B6BFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: _kPurple.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(profile.puntostotales.toString(), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(width: 4),
                  const Text('pts', style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.workspace_premium, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                profile.puntosFaltantesTop1 > 0 ? 'Faltan ${profile.puntosFaltantesTop1} pts para el 1er puesto' : '¡Eres el 1er puesto!', 
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigate to ranking
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Ver ranking', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildAchievementCard(context, 'Madrugador', 'Completado', Icons.wb_twilight, _kOrange, '+100 pts'),
          const SizedBox(width: 12),
          _buildAchievementCard(context, '7 Días Racha', 'Completado', Icons.local_fire_department, _kOrange, '+150 pts'),
          const SizedBox(width: 12),
          _buildAchievementCard(context, 'Mente Clara', 'En curso (3/5)', Icons.self_improvement, _kPurple, '+200 pts', isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, String title, String status, IconData icon, Color color, String points, {bool isCompleted = true}) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: _kPurple, size: 12),
              const SizedBox(width: 4),
              Text(points, style: TextStyle(fontSize: 10, color: isCompleted ? _kPurple : Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFriendTile(BuildContext context, {required String name, required String streak, required String subtitle, String? avatarUrl, required String actionType}) {
    final isSaludar = actionType == 'Saludar';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurfaceVariant) : null,
              ),
              if (isSaludar) // Mocking a badge for some
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: _kOrange, shape: BoxShape.circle),
                  child: Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.surface, size: 10),
                )
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    children: [
                      TextSpan(text: streak, style: const TextStyle(color: _kOrange, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' • $subtitle'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Text(actionType, style: const TextStyle(color: _kPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text(isSaludar ? '👋' : '🎯', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
