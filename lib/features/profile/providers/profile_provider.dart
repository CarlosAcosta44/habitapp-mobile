import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/user_profile.dart';
import '../data/models/user_stats.dart';
import '../data/profile_repository.dart';
import '../../auth/data/auth_repository.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserStats> profileStats(Ref ref) async {
  return ref.watch(profileRepositoryProvider).getUserStats();
}

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
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfile());
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = await repository.updateProfile(data);
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    final currentProfile = state.value;
    if (currentProfile == null || currentProfile.correo == null) {
      throw Exception('Perfil no encontrado o sin correo');
    }

    try {
      final authRepo = ref.read(authRepositoryProvider);
      
      // 1. Validate current password by attempting to login
      try {
        await authRepo.login(currentProfile.correo!, currentPassword);
      } catch (e) {
        throw Exception('La contraseña actual es incorrecta');
      }

      // 2. Update to new password
      await authRepo.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> uploadAvatar(String filePath) async {
    state = AsyncValue.loading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.uploadAvatar(filePath);
      await refreshProfile();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void clearProfile() {
    state = AsyncValue.data(null);
  }
}
