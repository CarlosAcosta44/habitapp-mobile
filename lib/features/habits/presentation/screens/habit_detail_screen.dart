import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/habits_provider.dart';
import '../../data/models/category_model.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/habits_repository.dart';

const _kBlueLight = Color(0xFFEFF5FF);
const _kRed = Color(0xFFF76B6B);

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
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 16),
              Text('Editar Hábito', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              FutureBuilder<List<CategoryModel>>(
                future: ref.read(habitsRepositoryProvider).getCategorias(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final categories = snapshot.data!;
                  
                  if (selectedCategoryId == null && categories.isNotEmpty) {
                    selectedCategoryId = categories.first.id;
                  }
                  
                  final selectedCat = categories.firstWhere(
                    (c) => c.id == selectedCategoryId,
                    orElse: () => categories.first,
                  );

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          ),
                          child: Column(
                            children: [
                              Icon(_getCategoryIcon(selectedCat.icono), size: 32, color: Theme.of(context).colorScheme.primary),
                              SizedBox(height: 8),
                              Row(
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
                        SizedBox(height: 12),
                        Text(selectedCat.nombre, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: categories.map((cat) {
                              final isSelected = cat.id == selectedCategoryId;
                              return GestureDetector(
                                onTap: () => setState(() => selectedCategoryId = cat.id),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).colorScheme.surface : Colors.transparent,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0, 2))] : [],
                                    border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) : null,
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(cat.icono),
                                    size: 16,
                                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
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
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('META DIARIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant, letterSpacing: 1)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.flag_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: metaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              controller: unidadController,
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                              decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('/ día', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hábito actualizado')));
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: Text('Guardar cambios', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 16, fontWeight: FontWeight.bold)),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hábito movido a $newState')));
        if (newState == 'Archivado' || newState == 'Inactivo' || newState == 'Completado') {
          context.pop();
        }
      }
      Future.delayed(Duration(milliseconds: 300), () {
        ref.invalidate(habitStatsProvider(widget.habitId));
        ref.read(habitsDashboardProvider.notifier).refresh();
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteHabit() async {
    final conf = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('¿Eliminar Hábito?'),
        content: Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text('Eliminar', style: TextStyle(color: _kRed))),
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
    // También observamos el dashboard para recibir actualizaciones optimistas de progreso
    final dashboardState = ref.watch(habitsDashboardProvider);
    final localHabit = dashboardState.value?.where((h) => h.id == widget.habitId).firstOrNull;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: state.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error al cargar: $e')),
          data: (habit) {
            // Si hay datos locales más recientes del dashboard, usar ese progresoHoy
            final habitConProgreso = localHabit != null
                ? habit.copyWith(progresoHoy: localHabit.progresoHoy)
                : habit;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () => context.pop(),
                  ),
                  title: Column(
                    children: [
                      Text('Detalle del Hábito', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('RUTINA ${(habit.estado ?? 'Activo').toUpperCase()}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onSurface), onPressed: () {}),
                    IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface), onPressed: () => _showEditOptions(context, habit)),
                  ],
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Main Card
                      _buildMainCard(habitConProgreso),
                      SizedBox(height: 24),
                      
                      // Stats Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatBox('Racha actual', '${habit.rachaActual} días', Icons.local_fire_department, Colors.orange),
                          _buildStatBox('Mejor racha', '${habit.mejorRacha} días', Icons.emoji_events, Theme.of(context).colorScheme.primary),
                          _buildStatBox('Tasa de éxito', '${habit.tasaExito}%', Icons.check_circle, Colors.green),
                          _buildStatBox('Total cumplido', '${habit.totalCumplido} veces', Icons.done_all, Theme.of(context).colorScheme.onSurfaceVariant),
                        ],
                      ),
                      SizedBox(height: 24),

                      // History
                      _buildHistorySection(habitConProgreso),
                      SizedBox(height: 24),

                      // Motivation
                      if ((habit.descripcion ?? '').isNotEmpty) ...[
                        _buildMotivationBlock(habit.descripcion!),
                        SizedBox(height: 24),
                      ],

                      // Recordatorios (Mocked UI)
                      _buildRecordatoriosSection(),
                      SizedBox(height: 32),

                      // Actions
                      FilledButton.icon(
                        onPressed: () => _showEditOptions(context, habit),
                        icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.surface),
                        label: Text('Editar Hábito', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold)),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          minimumSize: Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _updateState('Archivado'),
                              icon: Icon(Icons.archive, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                              label: Text('Archivar', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _deleteHabit,
                        icon: Icon(Icons.delete_outline, color: _kRed),
                        label: Text('Eliminar Hábito', style: TextStyle(color: _kRed, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          backgroundColor: _kRed.withValues(alpha: 0.1),
                          minimumSize: Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      SizedBox(height: 40),
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_getCategoryIcon(habit.categoria?.icono), color: Theme.of(context).colorScheme.primary, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kBlueLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        habit.categoria?.nombre ?? 'Sin Categoría',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      habit.nombre,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Meta de hoy', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${habit.progresoHoy.toInt()}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary)),
                      Text(' / ${habit.metaDiaria.toInt()} ${habit.unidadMedida}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
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
                              final nuevoProgreso = (habit.progresoHoy - 1).clamp(0, habit.metaDiaria).toDouble();
                              // Actualizar UI local inmediatamente (evita freeze)
                              ref.read(habitsDashboardProvider.notifier).updateLocalProgress(widget.habitId, nuevoProgreso);
                              try {
                                await ref.read(habitsRepositoryProvider).avanzarProgreso(widget.habitId, -1);
                                ref.invalidate(habitStatsProvider(widget.habitId));
                                // Refrescar dashboard en el siguiente microtask
                                Future.microtask(() => ref.read(habitsDashboardProvider.notifier).refresh());
                              } catch (_) {
                                // revertir
                                ref.read(habitsDashboardProvider.notifier).updateLocalProgress(widget.habitId, habit.progresoHoy);
                              }
                            }
                          : null,
                      icon: Icon(Icons.remove, size: 20),
                      color: Theme.of(context).colorScheme.onSurface,
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: habit.diasSemana.contains(DateTime.now().weekday)
                        ? () async {
                            final nuevoProgreso = (habit.progresoHoy + 1).clamp(0, habit.metaDiaria).toDouble();
                            // Actualizar UI local inmediatamente
                            ref.read(habitsDashboardProvider.notifier).updateLocalProgress(widget.habitId, nuevoProgreso);
                            try {
                              await ref.read(habitsRepositoryProvider).avanzarProgreso(widget.habitId, 1);
                              ref.invalidate(habitStatsProvider(widget.habitId));
                              // Refrescar dashboard en el siguiente microtask
                              Future.microtask(() => ref.read(habitsDashboardProvider.notifier).refresh());
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Progreso incrementado')));
                            } catch (e) {
                              // revertir
                              ref.read(habitsDashboardProvider.notifier).updateLocalProgress(widget.habitId, habit.progresoHoy);
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        : null,
                    icon: Icon(Icons.add, size: 16),
                    label: Text('+1 ${habit.unidadMedida}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: habit.diasSemana.contains(DateTime.now().weekday) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: habit.metaDiaria > 0 ? (habit.progresoHoy / habit.metaDiaria).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 14),
              )
            ],
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildHistorySection(HabitModel habit) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Historial Reciente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 4),
          Text('Últimos 7 días', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 16),
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
                  color: completed ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  completed ? Icons.check : Icons.close,
                  color: completed ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurfaceVariant,
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary, size: 20),
              SizedBox(width: 8),
              Text('PROPÓSITO & MOTIVACIÓN', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '"$text"',
            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontStyle: FontStyle.italic, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordatoriosSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.notifications_active_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
              SizedBox(width: 12),
              Text('Recordatorios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _kBlueLight, borderRadius: BorderRadius.circular(12)),
                child: Text('Activos', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTimeChip('08:00 AM'),
              _buildTimeChip('12:00 PM'),
              _buildTimeChip('16:00 PM'),
              ActionChip(
                onPressed: () {},
                avatar: Icon(Icons.add, size: 16, color: Theme.of(context).colorScheme.primary),
                label: Text('Añadir recordatorio', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          SizedBox(height: 20),
          Divider(height: 1, color: Color(0xFFF3F3F3)),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.music_note, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
              SizedBox(width: 8),
              Text('Sonido de alerta:', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              Spacer(),
              Text('Campana de serenidad', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, size: 14, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 6),
          Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}
