import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/providers/habits_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../providers/retos_provider.dart';

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
    if (iconName == null) return Icons.category_outlined;
    switch (iconName.toLowerCase()) {
      case 'water_drop':
      case 'agua':
        return Icons.water_drop_outlined;
      case 'fitness_center':
      case 'deporte':
        return Icons.fitness_center;
      case 'self_improvement':
      case 'mindfulness':
      case 'mente':
        return Icons.self_improvement;
      case 'bedtime':
      case 'descanso':
        return Icons.bedtime_outlined;
      case 'restaurant':
      case 'nutricion':
        return Icons.restaurant_outlined;
      case 'checklist':
        return Icons.checklist_rtl_outlined;
      case 'salud':
        return Icons.favorite_outline;
      case 'lectura':
        return Icons.menu_book;
      default:
        return Icons.category_outlined;
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
    final retosAsync = ref.watch(retosProvider);
    final profileState = ref.watch(profileProvider);
    final now = DateTime.now();

    final selectedDate = now.add(Duration(days: _selectedDayOffset));
    final selectedWeekday = selectedDate.weekday;
    final selectedDateString = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

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
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo-habitapp.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.extension, color: _kBlue, size: 24),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'HabitApp',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kTextDark),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/profile'),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: _kPink.withValues(alpha: 0.15),
                              backgroundImage: (profileState.value?.fotoperfil != null)
                                  ? NetworkImage(profileState.value!.fotoperfil!)
                                  : null,
                              child: (profileState.value?.fotoperfil == null)
                                  ? const Icon(Icons.person_outline, color: _kPink, size: 20)
                                  : null,
                            ),
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
                      if (h.estado != 'Activo') return false;
                      if (h.diasSemana.isEmpty) return true;
                      return h.diasSemana.contains(selectedWeekday);
                    }).toList();

                    final completedCount = habits.where((h) => h.fechasCompletadas.contains(selectedDateString)).length;
                    final totalCount = habits.length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          
                          // ── Fila de Fecha y Nivel ──
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${selectedDate.day} ${_getMonthName(selectedDate.month)}, ${selectedDate.year}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kTextDark),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$completedCount de $totalCount hábitos',
                                          style: const TextStyle(fontSize: 13, color: _kTextGrey),
                                        ),
                                        Text(
                                          '${totalCount > 0 ? (completedCount / totalCount * 100).round() : 0}%',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _kBlue),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 8,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: totalCount > 0 ? completedCount / totalCount : 0,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor: const AlwaysStoppedAnimation(_kBlue),
                                        ),
                                      ),
                                    ),
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
                          
                          // ── Banner Paisaje Motivacional ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/paisaje-dashboard.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '«Cada nuevo amanecer es una nueva oportunidad»',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w800, 
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2))
                                    ],
                                  ),
                                ),
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
                            child: retosAsync.when(
                              data: (retos) {
                                if (retos.isEmpty) {
                                  return const Center(
                                    child: Text('No hay retos activos.', style: TextStyle(color: Colors.grey)),
                                  );
                                }
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  itemCount: retos.length,
                                  separatorBuilder: (_, i) => const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    final reto = retos[index];
                                    final color = index % 2 == 0 ? _kPink : const Color(0xFF0F8A5D);
                                    
                                    // Cálculo de progreso ficticio para demostración
                                    final progresoMock = index % 2 == 0 ? 0.2 : 0.45;
                                    final progressText = '${(progresoMock * 100).toInt()}% completado';

                                    return _ChallengeCard(
                                      title: reto['titulo'] ?? 'Reto',
                                      subtitle: reto['descripcion'] ?? 'Únete ahora',
                                      progressText: progressText,
                                      progress: progresoMock,
                                      color: color,
                                      badgeText: '${reto['puntosRecompensa'] ?? 50} pts',
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, _) => Center(child: Text('Error al cargar retos')),
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
                                    ? '${habit.progresoHoy.toInt()}/${habit.metaDiaria.toInt()}\n${habit.unidadMedida}' 
                                    : null;
                                final badgeText = isNumeric ? '${habit.rachaActual}d' : null;
                                
                                final isCompleted = _selectedDayOffset == 0 
                                    ? habit.completadoHoy 
                                    : habit.fechasCompletadas.contains(selectedDateString);

                                return GestureDetector(
                                  onTap: () => context.push('/habit/${habit.id}'),
                                  child: HabitCard(
                                    title: habit.nombre,
                                    subtitle: habit.descripcion ?? 'Sin descripción',
                                    icon: _getCategoryIcon(habit.categoria?.icono ?? habit.categoria?.nombre),
                                    iconColor: habit.categoria?.parsedColor ?? _kBlue,
                                    badgeText: badgeText,
                                    isCompleted: isCompleted,
                                    isNumeric: isNumeric,
                                    rightText: rightText,
                                    onToggle: _selectedDayOffset == 0 ? () {
                                      ref.read(habitsDashboardProvider.notifier).toggleHabit(habit.id);
                                    } : null,
                                  ),
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
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kTextDark), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: _kTextGrey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
