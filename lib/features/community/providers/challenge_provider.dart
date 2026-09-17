import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/community_repository.dart';
import '../data/models/challenge.dart';

part 'challenge_provider.g.dart';

@riverpod
class ChallengesNotifier extends _$ChallengesNotifier {
  @override
  FutureOr<List<Challenge>> build() async {
    return ref.watch(communityRepositoryProvider).getChallenges();
  }

  Future<void> joinChallenge(String challengeId) async {
    final previousState = state;

    if (state.value != null) {
      final updatedChallenges = state.value!.map((c) {
        if (c.id == challengeId) {
          return c.copyWith(isJoined: true);
        }
        return c;
      }).toList();

      state = AsyncData(updatedChallenges);
    }

    try {
      await ref.read(communityRepositoryProvider).joinChallenge(challengeId);
    } catch (e) {
      // Revert if API call fails
      state = previousState;
    }
  }
}
