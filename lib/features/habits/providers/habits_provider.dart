import 'package:riverpod_annotation/riverpod_annotation.dart';
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

@Riverpod(keepAlive: true)
class HabitsDashboardNotifier extends _$HabitsDashboardNotifier {
  @override
  Future<List<HabitModel>> build() async {
    final repository = ref.watch(habitsRepositoryProvider);
    return repository.getDashboardHabits();
  }

  /// Recarga la lista de hábitos desde la API
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(habitsRepositoryProvider);
      return repository.getDashboardHabits();
    });
  }

  /// Crea un nuevo hábito y recarga el dashboard
  Future<bool> createHabit(CreateHabitDto dto) async {
    final repository = ref.read(habitsRepositoryProvider);
    try {
      await repository.createHabit(dto);
      await refresh();
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Alterna el estado de completado de un hábito (Optimistic UI)
  Future<void> toggleHabit(String id) async {
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
    } catch (e) {
      // Revertir en caso de error
      state = AsyncValue.data(previousState);
    }
  }
}
