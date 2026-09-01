import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/user_profile.dart';
import '../data/profile_repository.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<UserProfile?> build() async {
    return _fetchProfile();
  }

  Future<UserProfile?> _fetchProfile() async {
    try {
      final repository = ref.read(profileRepositoryProvider);
      return await repository.getProfile();
    } catch (e) {
      // Si falla al obtener el perfil, devolvemos null
      return null;
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfile());
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = await repository.updateProfile(data);
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
  
  void clearProfile() {
    state = const AsyncValue.data(null);
  }
}
