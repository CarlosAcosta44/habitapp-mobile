import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../profile/providers/profile_provider.dart';
import '../data/models/category_model.dart';
import '../data/models/create_habit_dto.dart';
import '../data/models/habit_model.dart';
import '../data/repositories/habits_repository.dart';

part 'habits_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<CategoryModel>> categories(Ref ref) async {
  final repository = ref.watch(habitsRepositoryProvider);
  return repository.getCategorias();
}

@riverpod
Future<List<HabitModel>> archivedHabits(Ref ref) async {
  final repository = ref.watch(habitsRepositoryProvider);
  return repository.getArchivedHabits();
}

@Riverpod(keepAlive: true)
class HabitsDashboardNotifier extends _$HabitsDashboardNotifier {
  final Set<String> _togglingHabits = {};

  @override
  Future<List<HabitModel>> build() async {
    final repository = ref.watch(habitsRepositoryProvider);
    return repository.getDashboardHabits();
  }

  /// Recarga la lista de hábitos desde la API (sin pasar por loading para no freezar la UI)
  Future<void> refresh() async {
    try {
      final repository = ref.read(habitsRepositoryProvider);
      final newData = await repository.getDashboardHabits();
      state = AsyncValue.data(newData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Actualiza el progresoHoy de un hábito localmente (sin llamada a la API).
  /// Usar después de avanzarProgreso para reflejar el cambio al instante.
  void updateLocalProgress(String id, double nuevoProg) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.map((h) => h.id == id ? h.copyWith(progresoHoy: nuevoProg) : h).toList(),
    );
  }

  /// Crea un nuevo hábito y recarga el dashboard
  Future<HabitModel?> createHabit(CreateHabitDto dto) async {
    final repository = ref.read(habitsRepositoryProvider);
    try {
      final habit = await repository.createHabit(dto);
      await refresh();
      return habit;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Alterna el estado de completado de un hábito (Optimistic UI)
  Future<void> toggleHabit(String id) async {
    if (_togglingHabits.contains(id)) return;
    _togglingHabits.add(id);

    final previousState = state.value ?? [];
    
    // Actualización optimista del estado local
    final updatedList = previousState.map((habit) {
      if (habit.id == id) {
        final newCompletado = !habit.completadoHoy;
        return habit.copyWith(
          completadoHoy: newCompletado,
          progresoHoy: newCompletado ? habit.metaDiaria : 0.0,
        );
      }
      return habit;
    }).toList();

    state = AsyncValue.data(updatedList);

    try {
      final repository = ref.read(habitsRepositoryProvider);
      final targetHabit = previousState.firstWhere((h) => h.id == id);
      if (targetHabit.completadoHoy) {
        await repository.desmarcarCompletado(id);
      } else {
        await repository.marcarCompletado(id);
      }
      
      // Invalidar proveedores del perfil para actualizar los puntos
      ref.invalidate(profileProvider);
      ref.invalidate(profileStatsProvider);
    } catch (e) {
      // Revertir en caso de error
      state = AsyncValue.data(previousState);
    } finally {
      _togglingHabits.remove(id);
    }
  }

  /// Desarchiva un hábito
  Future<bool> unarchiveHabit(String id) async {
    try {
      final repository = ref.read(habitsRepositoryProvider);
      await repository.updateHabit(id, {'estado': 'Activo'});
      ref.invalidate(archivedHabitsProvider);
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }
}
