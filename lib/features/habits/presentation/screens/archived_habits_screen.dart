import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habits_provider.dart';
import '../../data/models/habit_model.dart';

const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);
const _kPink = Color(0xFFF94C84);

class ArchivedHabitsScreen extends ConsumerWidget {
  const ArchivedHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedAsync = ref.watch(archivedHabitsProvider);

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Hábitos Archivados',
          style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: archivedAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return const Center(
              child: Text(
                'No tienes hábitos archivados',
                style: TextStyle(color: _kTextGrey, fontSize: 16),
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
        loading: () => const Center(child: CircularProgressIndicator(color: _kPink)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: _kPink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getCategoryIcon(habit.categoria?.icono),
              color: _kPink,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _kTextDark,
                  ),
                ),
                if (habit.descripcion != null && habit.descripcion!.isNotEmpty)
                  Text(
                    habit.descripcion!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _kTextGrey,
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
            icon: const Icon(Icons.unarchive, color: _kPink),
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
