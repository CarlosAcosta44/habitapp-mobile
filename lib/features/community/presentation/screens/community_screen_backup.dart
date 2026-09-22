import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/community_provider.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Comunidad'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Foros'),
            Tab(text: 'Retos'),
            Tab(text: 'Artículos'),
            Tab(text: 'Especialistas'),
            Tab(text: 'Hábitos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ForosTab(),
          _RetosTab(),
          _ArticulosTab(),
          _EspecialistasTab(),
          _HabitosComunitariosTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // No necesitamos crear foros por ahora, los administradores lo harían, 
          // pero podríamos permitir sugerencias. Por ahora mostrar mensaje
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Los foros son creados por administradores.')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ForosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forosAsync = ref.watch(forumsProvider);

    return forosAsync.when(
      data: (foros) {
        if (foros.isEmpty) return const Center(child: Text('No hay foros activos.'));
        return ListView.builder(
          itemCount: foros.length,
          itemBuilder: (context, index) {
            final foro = foros[index];
            return ListTile(
              title: Text(foro['titulo'] ?? 'Foro'),
              subtitle: Text(foro['descripcion'] ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/community/forum/${foro['idforo']}', extra: foro['titulo']);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _RetosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final retosAsync = ref.watch(retosProvider);

    return retosAsync.when(
      data: (retos) {
        if (retos.isEmpty) return const Center(child: Text('No hay retos disponibles.'));
        return ListView.builder(
          itemCount: retos.length,
          itemBuilder: (context, index) {
            final reto = retos[index];
            return ListTile(
              title: Text(reto['titulo'] ?? 'Reto'),
              subtitle: Text(reto['descripcion'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () {
                  ref.read(retosProvider.notifier).joinReto(reto['idreto']);
                },
                child: const Text('Unirse'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _ArticulosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articulosAsync = ref.watch(articulosProvider);

    return articulosAsync.when(
      data: (articulos) {
        if (articulos.isEmpty) return const Center(child: Text('No hay artículos disponibles.'));
        return ListView.builder(
          itemCount: articulos.length,
          itemBuilder: (context, index) {
            final art = articulos[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(art['titulo'] ?? 'Artículo'),
                subtitle: Text(
                  art['contenido'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _EspecialistasTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final especialistasAsync = ref.watch(especialistasProvider);

    return especialistasAsync.when(
      data: (especialistas) {
        if (especialistas.isEmpty) return const Center(child: Text('No hay especialistas disponibles.'));
        return ListView.builder(
          itemCount: especialistas.length,
          itemBuilder: (context, index) {
            final esp = especialistas[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: esp['fotoperfil'] != null ? NetworkImage(esp['fotoperfil']) : null,
                child: esp['fotoperfil'] == null ? const Icon(Icons.person) : null,
              ),
              title: Text('${esp['nombre']} ${esp['apellido']}'),
              subtitle: Text(esp['correo'] ?? ''),
              trailing: const Icon(Icons.contact_mail),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _HabitosComunitariosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(communityHabitsProvider);

    return habitsAsync.when(
      data: (habits) {
        if (habits.isEmpty) return const Center(child: Text('No hay hábitos comunitarios disponibles.'));
        return ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            final userName = habit['gestion']?['usuarios']?['nombre'] ?? 'Usuario Anónimo';
            final userPic = habit['gestion']?['usuarios']?['fotoperfil'];
            
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: userPic != null ? NetworkImage(userPic) : null,
                  child: userPic == null ? const Icon(Icons.person) : null,
                ),
                title: Text(habit['nombre'] ?? 'Hábito'),
                subtitle: Text('${habit['descripcion'] ?? ''}\nCreado por: $userName'),
                isThreeLine: true,
                trailing: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(communityHabitsProvider.notifier).cloneHabit(habit['idhabito']);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hábito clonado con éxito. Revisa tu Dashboard.'), backgroundColor: Colors.green),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al clonar: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: const Text('Clonar'),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
