import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/community_provider.dart';
import '../../providers/community_feed_provider.dart';
import '../../../habits/providers/habits_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);

class ShareHabitBottomSheet extends ConsumerStatefulWidget {
  const ShareHabitBottomSheet({super.key});

  @override
  ConsumerState<ShareHabitBottomSheet> createState() => _ShareHabitBottomSheetState();
}

class _ShareHabitBottomSheetState extends ConsumerState<ShareHabitBottomSheet> {
  final Set<String> _sharedHabits = {}; // Mantiene track de los hábitos compartidos localmente
  final Set<String> _sharingHabits = {}; // Hábitos en proceso de compartir

  Future<void> _shareHabit(String habitId) async {
    if (_sharedHabits.contains(habitId) || _sharingHabits.contains(habitId)) return;

    setState(() {
      _sharingHabits.add(habitId);
    });

    try {
      await ref.read(communityHabitsProvider.notifier).shareHabit(habitId);
      setState(() {
        _sharedHabits.add(habitId);
      });
      ref.read(communityFeedProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Hábito compartido con la comunidad!'),
            backgroundColor: _kGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al compartir: ${e.toString().replaceAll('Exception:', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sharingHabits.remove(habitId);
        });
      }
    }
  }

  Widget _buildShareButtonChild(bool isSharing, bool isShared) {
    if (isSharing) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isShared) ...[
          const Icon(Icons.check, size: 16),
          const SizedBox(width: 4),
        ],
        Text(
          isShared ? 'Compartido' : 'Compartir',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHabitItemTile(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic habit,
    List<dynamic> communityHabits,
  ) {
    final isSharedLocally = _sharedHabits.contains(habit.id);
    final isSharedInDb = communityHabits.any((ch) => ch.isMine && ch.title == habit.nombre);
    final isShared = isSharedLocally || isSharedInDb;
    final isSharing = _sharingHabits.contains(habit.id);
    final streak = habit.rachaActual;
    final habitColor = habit.categoria?.parsedColor ?? _kBlue;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: habitColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.star_border_rounded, color: habitColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.nombre,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 14, color: _kGreen),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Racha de $streak días • ${habit.progresoHoy.toInt()}/${habit.metaDiaria} ${habit.unidadMedida} hoy',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: isShared ? null : () => _shareHabit(habit.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: (isShared ? _kGreen : _kBlue).withValues(alpha: 0.1),
                foregroundColor: isShared ? _kGreen : _kBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: _buildShareButtonChild(isSharing, isShared),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final habitsState = ref.watch(habitsDashboardProvider);
    final communityHabits = ref.watch(communityFeedProvider).habits;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con botón cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Compartir Hábito',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'Elige uno de tus hábitos activos para inspirar y ayudar a otros miembros de la comunidad.',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Lista de Hábitos
          Expanded(
            child: habitsState.when(
              loading: () => const Center(child: CircularProgressIndicator(color: _kBlue)),
              error: (e, _) => Center(child: Text('Error al cargar hábitos: $e')),
              data: (habits) {
                if (habits.isEmpty) {
                  return const Center(child: Text('No tienes hábitos activos para compartir.'));
                }
                
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: habits.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _buildHabitItemTile(
                    theme,
                    colorScheme,
                    habits[index],
                    communityHabits,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Al compartir, solo se mostrará el nombre y tu consejo del hábito. Tus notas y datos privados no serán visibles.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
