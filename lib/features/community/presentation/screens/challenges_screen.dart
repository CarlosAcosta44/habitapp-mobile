import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/community_provider.dart';
import '../../data/models/reto_model.dart';
import '../widgets/challenge_card.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}
class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retos de la Comunidad'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(retosProvider.notifier).refresh();
            },
            tooltip: 'Actualizar retos',
          ),
        ],
      ),
      body: const ChallengesView(),
    );
  }
}

class ChallengesView extends ConsumerStatefulWidget {
  const ChallengesView({super.key});

  @override
  ConsumerState<ChallengesView> createState() => _ChallengesViewState();
}

class _ChallengesViewState extends ConsumerState<ChallengesView> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final retosAsync = ref.watch(retosProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(retosProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: retosAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error al cargar retos: $err'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.read(retosProvider.notifier).refresh(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          data: (retosRaw) {
            final allRetos = retosRaw.map((r) => RetoModel.fromJson(r as Map<String, dynamic>)).toList();
            final activeRetos = allRetos.where((r) => r.isJoined).toList();
            final availableRetos = allRetos.where((r) => !r.isJoined).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tus Retos Activos
                if (activeRetos.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Tus Retos Activos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF5FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${activeRetos.length} en curso',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D82FA)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...activeRetos.map((reto) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ChallengeCard(
                      reto: reto,
                      onTap: () => context.push('/community/challenge/${reto.id}'),
                      onJoinTap: () {}, 
                    ),
                  )),
                  const SizedBox(height: 24),
                ],

                // Retos Disponibles
                Row(
                  children: [
                    const Text(
                      'Retos Disponibles',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${availableRetos.length})',
                      style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                if (availableRetos.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay más retos disponibles por el momento.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                ...availableRetos.map((reto) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ChallengeCard(
                    reto: reto,
                    onTap: () => context.push('/community/challenge/${reto.id}'),
                    onJoinTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidad no disponible')),
                      );
                    },
                  ),
                )),

                const SizedBox(height: 12),

                // Footer banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D82FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.group_add_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              '¿Quieres desafiar a tus amigos?',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Crea un reto grupal con reglas a tu medida y ranking privado de amigos.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.3),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Funcionalidad no disponible')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2D82FA),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Crear Reto Personalizado', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

