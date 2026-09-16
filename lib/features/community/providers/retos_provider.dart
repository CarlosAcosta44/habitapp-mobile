import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/reto_model.dart';
import '../data/repositories/community_repository.dart';

part 'retos_provider.g.dart';

@Riverpod(keepAlive: true)
class CommunityRetosNotifier extends _$CommunityRetosNotifier {
  @override
  Future<List<RetoModel>> build() async {
    final repository = ref.watch(communityRepositoryProvider);
    return repository.getRetos();
  }

  /// Recarga la lista de retos sin mostrar pantalla de carga total
  Future<void> refresh() async {
    try {
      final repository = ref.read(communityRepositoryProvider);
      final list = await repository.getRetos();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Unirse a un reto determinado con actualización optimista de la interfaz
  Future<bool> joinChallenge(String id) async {
    final repository = ref.read(communityRepositoryProvider);
    final previousState = state;

    if (state.hasValue) {
      final currentList = state.value!;
      final updatedList = currentList.map((reto) {
        if (reto.id == id) {
          return reto.copyWith(
            isJoined: true,
            participantCount: reto.participantCount + 1,
            currentProgress: reto.currentProgress == 0 ? 1 : reto.currentProgress,
          );
        }
        return reto;
      }).toList();

      state = AsyncValue.data(updatedList);
    }

    final success = await repository.joinChallenge(id);
    if (!success) {
      state = previousState; // Revertir en caso de falla
    }
    return success;
  }
}
