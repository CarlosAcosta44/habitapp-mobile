import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/friend_model.dart';
import '../data/repositories/friends_repository.dart';

final friendsProvider = FutureProvider<List<FriendModel>>((ref) async {
  final repository = ref.watch(friendsRepositoryProvider);
  return repository.getFriends();
});
