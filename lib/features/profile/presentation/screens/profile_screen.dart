import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../providers/friends_provider.dart';
import '../../../habits/providers/habits_provider.dart';

const _kPurple = Color(0xFF6B48FF);
const _kLightPurple = Color(0xFFF4F0FB);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);
const _kOrange = Color(0xFFFF7A59);
const _kBg = Color(0xFFFAF9FF);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final friendsState = ref.watch(friendsProvider);

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: profileState.when(
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('No se pudo cargar el perfil'));
            }

            return CustomScrollView(
              slivers: [
                // ── AppBar ──
                SliverAppBar(
                  backgroundColor: _kBg,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: _kTextDark),
                    onPressed: () => context.pop(),
                  ),
                  title: const Text(
                    'Mi Perfil',
                    style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  centerTitle: true,
                  actions: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.05), shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: _kTextDark, size: 20),
                        onPressed: () => context.push('/settings'),
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
                      const SizedBox(height: 24),

                      // ── Basic Stats Row ──
                      _buildBasicStatsRow(ref),
                      const SizedBox(height: 24),

                      // ── Puntos de Bienestar ──
                      _buildSectionHeader('Puntos de Bienestar', badgeText: '+320 pts esta semana', icon: Icons.stars, iconColor: _kPurple),
                      const SizedBox(height: 12),
                      _buildPointsCard(profile),
                      const SizedBox(height: 32),

                      // ── Logros ──
                      _buildSectionHeader('Logros', subtitle: '12 de 24', actionText: 'Ver todos ->', icon: Icons.workspace_premium, iconColor: _kPurple),
                      const SizedBox(height: 16),
                      _buildAchievementsRow(),
                      const SizedBox(height: 32),

                      // ── Amigos ──
                      _buildSectionHeader('Amigos', subtitle: '18 amigos', actionText: '+ Añadir amigos', icon: Icons.people_alt_outlined, iconColor: _kPurple),
                      const SizedBox(height: 16),
                      
                      // Lista de amigos desde el backend
                      friendsState.when(
                        data: (friends) {
                          if (friends.isEmpty) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Aún no tienes amigos añadidos.', style: TextStyle(color: _kTextGrey)),
                            ));
                          }
                          return Column(
                            children: friends.map((friend) => _buildFriendTile(
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contact_page_outlined, size: 18, color: _kTextDark),
                            SizedBox(width: 8),
                            Text('Buscar amigos por contacto o enlace compartido', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kTextDark)),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              Text('${profile.nombre} ${profile.apellido}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _kTextDark)),
              const SizedBox(height: 4),
              Text(profile.correo ?? '', style: const TextStyle(fontSize: 13, color: _kTextGrey)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: _kLightPurple, borderRadius: BorderRadius.circular(12)),
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
                    backgroundColor: _kLightPurple,
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
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: _kPurple.withValues(alpha: 0.2), blurRadius: 16, spreadRadius: 4)],
              ),
              child: CircleAvatar(
                radius: 44,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: profile.fotoperfil != null ? NetworkImage(profile.fotoperfil!) : null,
                child: profile.fotoperfil == null ? const Icon(Icons.person, color: Colors.grey, size: 40) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicStatsRow(WidgetRef ref) {
    final statsAsync = ref.watch(profileStatsProvider);
    
    return Row(
      children: [
        _buildStatBox(
          statsAsync.when(data: (s) => s.activeHabitsCount.toString(), loading: () => '-', error: (e, st) => '!'),
          'Hábitos\nactivos'
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          statsAsync.when(data: (s) => '${s.tasaExito}%', loading: () => '-', error: (e, st) => '!'),
          'Tasa de\néxito'
        ),
        const SizedBox(width: 12),
        _buildStatBox(
          statsAsync.when(data: (s) => s.diasTotales.toString(), loading: () => '-', error: (e, st) => '!'),
          'Días\ntotales'
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kPurple)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: _kTextGrey, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle, String? actionText, required IconData icon, required Color iconColor, String? badgeText}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _kTextDark)),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: _kTextGrey)),
        ],
        if (badgeText != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: _kLightPurple, borderRadius: BorderRadius.circular(12)),
            child: Text(badgeText, style: const TextStyle(fontSize: 10, color: _kPurple, fontWeight: FontWeight.bold)),
          ),
        ],
        const Spacer(),
        if (actionText != null)
          Text(actionText, style: const TextStyle(fontSize: 12, color: _kPurple, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPointsCard(dynamic profile) {
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
              InkWell(
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

  Widget _buildAchievementsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildAchievementCard('Madrugador', 'Completado', Icons.wb_twilight, _kOrange, '+100 pts'),
          const SizedBox(width: 12),
          _buildAchievementCard('7 Días Racha', 'Completado', Icons.local_fire_department, _kOrange, '+150 pts'),
          const SizedBox(width: 12),
          _buildAchievementCard('Mente Clara', 'En curso (3/5)', Icons.self_improvement, _kPurple, '+200 pts', isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String status, IconData icon, Color color, String points, {bool isCompleted = true}) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kTextDark)),
          const SizedBox(height: 4),
          Text(status, style: const TextStyle(fontSize: 10, color: _kTextGrey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: _kPurple, size: 12),
              const SizedBox(width: 4),
              Text(points, style: TextStyle(fontSize: 10, color: isCompleted ? _kPurple : _kTextGrey, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFriendTile({required String name, required String streak, required String subtitle, String? avatarUrl, required String actionType}) {
    final isSaludar = actionType == 'Saludar';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
              ),
              if (isSaludar) // Mocking a badge for some
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: _kOrange, shape: BoxShape.circle),
                  child: const Icon(Icons.local_fire_department, color: Colors.white, size: 10),
                )
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _kTextDark)),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11, color: _kTextGrey),
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
            decoration: BoxDecoration(color: _kLightPurple, borderRadius: BorderRadius.circular(12)),
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
