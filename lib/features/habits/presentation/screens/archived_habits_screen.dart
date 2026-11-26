import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habits_provider.dart';
import '../../data/models/habit_model.dart';


class ArchivedHabitsScreen extends ConsumerWidget {
  const ArchivedHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedAsync = ref.watch(archivedHabitsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Hábitos Archivados',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: archivedAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Text(
                'No tienes hábitos archivados',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _ArchivedHabitCard(habit: habit);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _ArchivedHabitCard extends ConsumerWidget {
  final HabitModel habit;

  const _ArchivedHabitCard({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getCategoryIcon(habit.categoria?.icono),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (habit.descripcion != null && habit.descripcion!.isNotEmpty)
                  Text(
                    habit.descripcion!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final success = await ref.read(habitsDashboardProvider.notifier).unarchiveHabit(habit.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hábito desarchivado exitosamente')),
                );
              }
            },
            icon: Icon(Icons.unarchive, color: Theme.of(context).colorScheme.secondary),
            tooltip: 'Desarchivar',
          )
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? icono) {
    switch (icono) {
      case 'deporte':
        return Icons.fitness_center;
      case 'agua':
        return Icons.local_drink;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'nutricion':
        return Icons.restaurant;
      case 'checklist':
        return Icons.checklist;
      case 'salud':
        return Icons.favorite;
      case 'lectura':
        return Icons.menu_book;
      default:
        return Icons.category_outlined;
    }
  }
}
