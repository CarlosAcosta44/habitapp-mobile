import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/coach_repository.dart';
import '../../domain/client_summary.dart';
import '../../domain/routine_summary.dart';

part 'assign_routine_controller.g.dart';

@riverpod
Future<List<ClientSummary>> availableClients(Ref ref) {
  return ref.watch(coachRepositoryProvider).getClients();
}

@riverpod
Future<List<RoutineSummary>> availableRoutines(Ref ref) {
  return ref.watch(coachRepositoryProvider).getRoutines();
}

@riverpod
class AssignRoutineController extends _$AssignRoutineController {
  @override
  FutureOr<void> build() {}

  Future<void> assign({required String clientId, required String routineId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(coachRepositoryProvider).assignRoutine(clientId: clientId, routineId: routineId)
    );
  }
}
