import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/habits_provider.dart';
import '../../data/models/category_model.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/habits_repository.dart';

const _kBlue = Color(0xFF2D82FA);
const _kBlueLight = Color(0xFFEFF5FF);
const _kRed = Color(0xFFF76B6B);
const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

final habitStatsProvider = FutureProvider.family<HabitModel, String>((ref, id) async {
  return ref.read(habitsRepositoryProvider).getHabitStats(id);
});

class HabitDetailScreen extends ConsumerStatefulWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  
  IconData _getCategoryIcon(String? iconName) {
    if (iconName == null) return Icons.category_outlined;
    switch (iconName.toLowerCase()) {
      case 'water_drop':
      case 'agua':
        return Icons.water_drop;
      case 'fitness_center':
      case 'deporte':
        return Icons.fitness_center;
      case 'self_improvement':
      case 'mindfulness':
      case 'mente':
        return Icons.self_improvement;
      case 'bedtime':
      case 'descanso':
        return Icons.bedtime;
      case 'restaurant':
      case 'nutricion':
        return Icons.restaurant;
      case 'checklist':
        return Icons.checklist;
      case 'salud':
        return Icons.favorite;
      case 'lectura':
        return Icons.menu_book;
      default:
        return Icons.category;
    }
  }

  void _showEditOptions(BuildContext context, HabitModel habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _buildEditSheet(context, habit),
    );
  }

  Widget _buildEditSheet(BuildContext context, HabitModel habit) {
    final metaController = TextEditingController(text: habit.metaDiaria.toString());
    final unidadController = TextEditingController(text: habit.unidadMedida);
    String? selectedCategoryId = habit.categoria?.id;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('Editar Hábito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              FutureBuilder<List<CategoryModel>>(
                future: ref.read(habitsRepositoryProvider).getCategorias(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final categories = snapshot.data!;
                  
                  if (selectedCategoryId == null && categories.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() => selectedCategoryId = categories.first.id);
                    });
                  }
                  
                  final selectedCat = categories.firstWhere(
                    (c) => c.id == selectedCategoryId,
                    orElse: () => categories.first,
                  );

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _kBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Icon(_getCategoryIcon(selectedCat.icono), size: 32, color: _kBlue),
                              const SizedBox(height: 8),
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_fire_department, color: Color(0xFF0F8A5D), size: 12),
                                  SizedBox(width: 4),
                                  Text('0d racha', style: TextStyle(color: Color(0xFF0F8A5D), fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(selectedCat.nombre, style: const TextStyle(fontSize: 12, color: _kTextGrey)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _kBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: categories.map((cat) {
                              final isSelected = cat.id == selectedCategoryId;
                              return GestureDetector(
                                onTap: () => setState(() => selectedCategoryId = cat.id),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
                                    border: isSelected ? Border.all(color: _kBlue, width: 1.5) : null,
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(cat.icono),
                                    size: 16,
                                    color: isSelected ? _kBlue : Colors.grey.shade400,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('META DIARIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.flag_outlined, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _kBg,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: metaController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kTextDark),
                              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _kBg,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: unidadController,
                              style: const TextStyle(fontSize: 12, color: _kTextDark),
                              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('/ día', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    final meta = double.tryParse(metaController.text) ?? habit.metaDiaria.toDouble();
                    final unidad = unidadController.text;
                    final updateData = <String, dynamic>{
                      'metaDiaria': meta,
                      'unidadMedida': unidad,
                    };
                    if (selectedCategoryId != null) {
                      updateData['idCategoria'] = selectedCategoryId;
                    }
                    try {
                      await ref.read(habitsRepositoryProvider).updateHabit(widget.habitId, updateData);
                      ref.invalidate(habitStatsProvider(widget.habitId));
                      ref.read(habitsDashboardProvider.notifier).refresh();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hábito actualizado')));
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: const Text('Guardar cambios', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> _updateState(String newState) async {
    try {
      await ref.read(habitsRepositoryProvider).updateHabit(widget.habitId, {'estado': newState});
      ref.invalidate(habitStatsProvider(widget.habitId));
      ref.read(habitsDashboardProvider.notifier).refresh();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hábito movido a $newState')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteHabit() async {
    final conf = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('¿Eliminar Hábito?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: _kRed))),
        ],
      )
    );
    if (conf == true) {
      try {
        await ref.read(habitsRepositoryProvider).deleteHabit(widget.habitId);
        ref.read(habitsDashboardProvider.notifier).refresh();
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(habitStatsProvider(widget.habitId));

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error al cargar: $e')),
          data: (habit) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: _kBg,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: _kTextDark),
                    onPressed: () => context.pop(),
                  ),
                  title: Column(
                    children: [
                      const Text('Detalle del Hábito', style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('RUTINA ${(habit.estado ?? 'Activo').toUpperCase()}', style: const TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(icon: const Icon(Icons.share, color: _kTextDark), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.more_vert, color: _kTextDark), onPressed: () => _showEditOptions(context, habit)),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Main Card
                      _buildMainCard(habit),
                      const SizedBox(height: 24),
                      
                      // Stats Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatBox('Racha actual', '${habit.rachaActual} días', Icons.local_fire_department, Colors.orange),
                          _buildStatBox('Mejor racha', '${habit.mejorRacha} días', Icons.emoji_events, _kBlue),
                          _buildStatBox('Tasa de éxito', '${habit.tasaExito}%', Icons.check_circle, Colors.green),
                          _buildStatBox('Total cumplido', '${habit.totalCumplido} veces', Icons.done_all, _kTextGrey),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // History
                      _buildHistorySection(habit),
                      const SizedBox(height: 24),

                      // Motivation
                      if ((habit.descripcion ?? '').isNotEmpty) ...[
                        _buildMotivationBlock(habit.descripcion!),
                        const SizedBox(height: 24),
                      ],

                      // Recordatorios (Mocked UI)
                      _buildRecordatoriosSection(),
                      const SizedBox(height: 32),

                      // Actions
                      FilledButton.icon(
                        onPressed: () => _showEditOptions(context, habit),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Editar Hábito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: FilledButton.styleFrom(
                          backgroundColor: _kBlue,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _updateState('Archivado'),
                              icon: const Icon(Icons.archive, color: _kTextGrey, size: 18),
                              label: const Text('Archivar', style: TextStyle(color: _kTextDark)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _updateState('Pausado'),
                              icon: const Icon(Icons.pause_circle_outline, color: _kTextGrey, size: 18),
                              label: const Text('Pausar', style: TextStyle(color: _kTextDark)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _deleteHabit,
                        icon: const Icon(Icons.delete_outline, color: _kRed),
                        label: const Text('Eliminar Hábito', style: TextStyle(color: _kRed, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          backgroundColor: _kRed.withValues(alpha: 0.1),
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainCard(HabitModel habit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getCategoryIcon(habit.categoria?.icono), color: _kBlue, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kBlueLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        habit.categoria?.nombre ?? 'Sin Categoría',
                        style: const TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      habit.nombre,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kTextDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Meta de hoy', style: TextStyle(fontSize: 12, color: _kTextGrey)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${habit.progresoHoy.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _kBlue)),
                      Text(' / ${habit.metaDiaria.toInt()} ${habit.unidadMedida}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kBlue)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: habit.diasSemana.contains(DateTime.now().weekday) && habit.progresoHoy > 0
                          ? () async {
                              try {
                                await ref.read(habitsRepositoryProvider).avanzarProgreso(widget.habitId, -1);
                                ref.invalidate(habitStatsProvider(widget.habitId));
                                ref.read(habitsDashboardProvider.notifier).refresh();
                              } catch (_) {
                                // silenciar error de decremento
                              }
                            }
                          : null,
                      icon: const Icon(Icons.remove, size: 20),
                      color: _kTextDark,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: habit.diasSemana.contains(DateTime.now().weekday)
                        ? () async {
                            try {
                              await ref.read(habitsRepositoryProvider).avanzarProgreso(widget.habitId, 1);
                              ref.invalidate(habitStatsProvider(widget.habitId));
                              ref.read(habitsDashboardProvider.notifier).refresh();
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progreso incrementado')));
                            } catch (e) {
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        : null,
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('+1 ${habit.unidadMedida}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: habit.diasSemana.contains(DateTime.now().weekday) ? _kBlue : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: habit.metaDiaria > 0 ? (habit.progresoHoy / habit.metaDiaria).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation(_kBlue),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: _kTextGrey)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 14),
              )
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _kTextDark)),
        ],
      ),
    );
  }

  Widget _buildHistorySection(HabitModel habit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial Reciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kTextDark)),
          const SizedBox(height: 4),
          const Text('Últimos 7 días', style: TextStyle(fontSize: 12, color: _kTextGrey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final bool completed = habit.historialReciente.length > index
                  ? habit.historialReciente[index].completado
                  : false;
              
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? _kBlue : Colors.grey.shade200,
                ),
                child: Icon(
                  completed ? Icons.check : Icons.close,
                  color: completed ? Colors.white : Colors.grey,
                  size: 16,
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildMotivationBlock(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.format_quote, color: _kBlue, size: 20),
              SizedBox(width: 8),
              Text('PROPÓSITO & MOTIVACIÓN', style: TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$text"',
            style: const TextStyle(fontSize: 14, color: _kTextDark, fontStyle: FontStyle.italic, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordatoriosSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: _kBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_active_outlined, color: _kBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Recordatorios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kTextDark)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _kBlueLight, borderRadius: BorderRadius.circular(12)),
                child: const Text('Activos', style: TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTimeChip('08:00 AM'),
              _buildTimeChip('12:00 PM'),
              _buildTimeChip('16:00 PM'),
              ActionChip(
                onPressed: () {},
                avatar: const Icon(Icons.add, size: 16, color: _kBlue),
                label: const Text('Añadir recordatorio', style: TextStyle(color: _kBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF3F3F3)),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.music_note, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text('Sonido de alerta:', style: TextStyle(color: _kTextGrey, fontSize: 12)),
              Spacer(),
              Text('Campana de serenidad', style: TextStyle(color: _kTextDark, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 14, color: _kBlue),
          const SizedBox(width: 6),
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kTextDark)),
        ],
      ),
    );
  }
}
