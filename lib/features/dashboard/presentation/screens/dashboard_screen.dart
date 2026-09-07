import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/providers/habits_provider.dart';
import '../../../profile/providers/profile_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kPink = Color(0xFFE22D6F);
const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

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
        return Icons.water_drop_rounded;
      case 'walk':
      case 'caminar':
      case 'correr':
      case 'deporte':
        return Icons.directions_walk_rounded;
      case 'read':
      case 'leer':
      case 'lectura':
        return Icons.menu_book_rounded;
      case 'mindfulness':
      case 'meditar':
      case 'salud':
        return Icons.self_improvement_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  String _getShortDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Lun';
      case DateTime.tuesday: return 'Mar';
      case DateTime.wednesday: return 'Mié';
      case DateTime.thursday: return 'Jue';
      case DateTime.friday: return 'Vie';
      case DateTime.saturday: return 'Sáb';
      case DateTime.sunday: return 'Dom';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsDashboardProvider);
    final now = DateTime.now();

    final selectedDate = now.add(Duration(days: _selectedDayOffset));
    final selectedWeekday = selectedDate.weekday;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(habitsDashboardProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Custom ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HabitApp',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kTextDark),
                      ),
                      Row(
                        children: [
                          const Text('Hábitos de hoy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kTextDark)),
                          const SizedBox(width: 12),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: _kPink.withValues(alpha: 0.15), shape: BoxShape.circle),
                            child: const Icon(Icons.person_outline, color: _kPink, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Divider(color: Colors.grey.shade200, height: 1),
                
                habitsAsync.when(
                  data: (allHabits) {
                    final habits = allHabits.where((h) {
                      if (h.diasSemana.isEmpty) return true;
                      return h.diasSemana.contains(selectedWeekday);
                    }).toList();

                    final completedCount = habits.where((h) => h.completadoHoy).length;
                    final totalCount = habits.length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          
                          // ── Fila de Fecha y Nivel ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: _kPink.withValues(alpha: 0.3), width: 1.5),
                                    ),
                                    child: const Icon(Icons.calendar_today_rounded, color: _kPink, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${selectedDate.day} ${_getMonthName(selectedDate.month)}, ${selectedDate.year}',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kTextDark),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$completedCount de $totalCount hábitos completados',
                                        style: const TextStyle(fontSize: 13, color: _kTextGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.eco_rounded, color: Color(0xFF0F8A5D), size: 14),
                                    SizedBox(width: 4),
                                    Text('Nivel 4', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F8A5D))),
                                    SizedBox(width: 4),
                                    Icon(Icons.circle, color: Color(0xFF0F8A5D), size: 6),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // ── Calendario Semanal Strip ──
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(7, (index) {
                                // 7 días, hoy en el medio (índice 3)
                                final offsetFromToday = index - 3; 
                                final dayDate = now.add(Duration(days: offsetFromToday));
                                final isSelected = offsetFromToday == _selectedDayOffset;
                                final dayName = _getShortDayName(dayDate.weekday);
                                
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedDayOffset = offsetFromToday),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? _kBlue : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          dayName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? Colors.white : _kTextGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${dayDate.day}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                            color: isSelected ? Colors.white : _kTextDark,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected 
                                                ? Colors.white 
                                                : (offsetFromToday == 0 ? const Color(0xFF0F8A5D) : Colors.transparent),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // ── Banner Calma Matutina ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF0F5), Color(0xFFFFF8E1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CALMA MATUTINA',
                                  style: TextStyle(color: _kPink, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 1),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Inicia tu día con serenidad',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kTextDark),
                                ),
                                SizedBox(height: 32), // Espacio extra imitando la imagen
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // ── Tus Retos ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tus retos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kTextDark)),
                              GestureDetector(
                                onTap: () {},
                                child: const Row(
                                  children: [
                                    Text('Ver todos', style: TextStyle(color: Color(0xFF0F8A5D), fontWeight: FontWeight.w700, fontSize: 13)),
                                    Icon(Icons.chevron_right, color: Color(0xFF0F8A5D), size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 170,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              children: const [
                                _ChallengeCard(
                                  title: 'Sin Azúcar',
                                  subtitle: 'Detox energy dip',
                                  progressText: '20% completado',
                                  progress: 0.2,
                                  color: _kPink,
                                  badgeText: '7 Días',
                                ),
                                SizedBox(width: 16),
                                _ChallengeCard(
                                  title: 'Meditación Diaria',
                                  subtitle: 'Mindful presence',
                                  progressText: '45% completado',
                                  progress: 0.45,
                                  color: Color(0xFF0F8A5D),
                                  badgeText: '14 Días',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── Encabezado Lista de Hábitos ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '$totalCount tareas',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _kTextGrey),
                                ),
                              ),
                              const Text('Ver todos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _kTextDark)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Lista de Hábitos ──
                          if (habits.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text('No hay hábitos programados para hoy.', style: TextStyle(color: Colors.grey)),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: habits.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final habit = habits[index];
                                final isNumeric = habit.metaDiaria > 1;
                                final rightText = isNumeric 
                                    ? '${habit.progresoHoy.toInt()}/${habit.metaDiaria.toInt()}\n${habit.unidadMedida ?? 'veces'}' 
                                    : null;
                                final badgeText = isNumeric ? '${habit.rachaActual}d' : (index == 2 ? 'Nuevo' : null);
                                
                                return HabitCard(
                                  title: habit.nombre,
                                  subtitle: habit.descripcion ?? 'Sin descripción',
                                  icon: _getCategoryIcon(habit.categoria?.icono ?? habit.categoria?.nombre),
                                  iconColor: habit.categoria?.parsedColor ?? _kBlue,
                                  badgeText: badgeText,
                                  isCompleted: habit.completadoHoy,
                                  isNumeric: isNumeric,
                                  rightText: rightText,
                                  onToggle: () {
                                    ref.read(habitsDashboardProvider.notifier).toggleHabit(habit.id);
                                  },
                                );
                              },
                            ),
                            
                          const SizedBox(height: 24),
                          
                          // ── Quote Footer ──
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _kPink.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.favorite_border_rounded, color: _kPink, size: 20),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '“Una mente en calma construye grandes logros.”',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _kTextDark),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Mantén el enfoque, ¡llevas el 67% de tu meta diaria!',
                                        style: TextStyle(fontSize: 12, color: _kTextGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 120), // Margen inferior para FAB y BottomNav
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator())),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Widgets Auxiliares
// ─────────────────────────────────────────────────────────

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progressText;
  final double progress;
  final Color color;
  final String badgeText;

  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.progress,
    required this.color,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kTextDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: _kTextGrey)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progreso', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kTextDark)),
              Text(progressText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}
