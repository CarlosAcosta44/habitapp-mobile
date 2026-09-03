import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../habits/presentation/widgets/daily_progress_bar.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/providers/habits_provider.dart';
import '../../../profile/providers/profile_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedDayOffset = 0; // 0 = Hoy, 1 = Mañana, etc.

  IconData _getCategoryIcon(String? iconName) {
    if (iconName == null) return Icons.fitness_center;
    switch (iconName.toLowerCase()) {
      case 'water':
      case 'agua':
      case 'beber':
        return Icons.water_drop;
      case 'walk':
      case 'caminar':
      case 'correr':
      case 'deporte':
        return Icons.directions_walk;
      case 'read':
      case 'leer':
      case 'lectura':
        return Icons.book;
      case 'mindfulness':
      case 'meditar':
      case 'salud':
        return Icons.self_improvement;
      default:
        return Icons.stars;
    }
  }

  String _getShortDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'LU';
      case DateTime.tuesday:
        return 'MA';
      case DateTime.wednesday:
        return 'MI';
      case DateTime.thursday:
        return 'JU';
      case DateTime.friday:
        return 'VI';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
        return 'DO';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsDashboardProvider);
    final profileAsync = ref.watch(profileProvider);
    final userName = profileAsync.value?.nombre ?? 'Usuario';
    final now = DateTime.now();

    // Fecha del día seleccionado en la barra de calendario
    final selectedDate = now.add(Duration(days: _selectedDayOffset));
    final selectedWeekday = selectedDate.weekday; // 1 = Lunes, 7 = Domingo

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(habitsDashboardProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Hola, $userName 👋',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                '¡Construyamos hábitos juntos!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              // Toggle Hoy / Foros
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text('Hoy', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Foros', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Calendar Bar interactiva de 7 días (US011)
              SizedBox(
                height: 72,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final dayDate = now.add(Duration(days: index));
                    final isSelected = index == _selectedDayOffset;
                    final dayName = _getShortDayName(dayDate.weekday);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayOffset = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 54,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? Colors.blue.withValues(alpha: 0.12)
                              : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${dayDate.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Habits rendering con filtro de días (US011)
              habitsAsync.when(
                data: (allHabits) {
                  // Filtrar hábitos programados para el día seleccionado
                  final habits = allHabits.where((h) {
                    if (h.diasSemana.isEmpty) return true;
                    return h.diasSemana.contains(selectedWeekday);
                  }).toList();

                  final completedCount = habits.where((h) => h.completadoHoy).length;
                  final totalCount = habits.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Progress Bar
                      DailyProgressBar(
                        completed: completedCount,
                        total: totalCount,
                      ),
                      const SizedBox(height: 24),

                      // Retos Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Retos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {},
                            child: const Text('VER MÁS', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.directions_run, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('¡Mejores corredores!', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Quedan 5 días 13 horas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Hábitos Header & Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDayOffset == 0
                                ? 'Mis Hábitos de Hoy ($completedCount/$totalCount)'
                                : 'Hábitos del ${_getShortDayName(selectedWeekday)} (${selectedDate.day}/${selectedDate.month})',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                            onPressed: () => context.push('/create-habit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (habits.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.event_available_outlined, size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                _selectedDayOffset == 0
                                    ? 'No tienes hábitos programados para hoy.'
                                    : 'Sin hábitos configurados para este día.',
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () => context.push('/create-habit'),
                                icon: const Icon(Icons.add),
                                label: const Text('Crear nuevo hábito'),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: habits.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            final progressRatio = habit.metaDiaria > 0
                                ? (habit.progresoHoy / habit.metaDiaria).clamp(0.0, 1.0)
                                : (habit.completadoHoy ? 1.0 : 0.0);

                            return HabitCard(
                              title: habit.nombre,
                              subtitle: '${habit.progresoHoy.toInt()}/${habit.metaDiaria.toInt()} ${habit.unidadMedida} • 🔥 Racha ${habit.rachaActual}d',
                              icon: _getCategoryIcon(habit.categoria?.icono ?? habit.categoria?.nombre),
                              progress: progressRatio,
                              isCompleted: habit.completadoHoy,
                              categoryName: habit.categoria?.nombre,
                              categoryColor: habit.categoria?.parsedColor,
                              onToggle: () {
                                ref
                                    .read(habitsDashboardProvider.notifier)
                                    .toggleHabit(habit.id);
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          'No se pudieron cargar los hábitos: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ref.read(habitsDashboardProvider.notifier).refresh();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
