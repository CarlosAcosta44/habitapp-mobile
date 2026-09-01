import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Future<bool> build() async {
    final storage = ref.watch(secureStorageProvider);
    // TODO(debug): Eliminar este bloque antes de release a producción
    if (kDebugMode) {
      await storage.delete(key: 'has_seen_onboarding');
    }
    final value = await storage.read(key: 'has_seen_onboarding');
    return value == 'true';
  }

  Future<void> completeOnboarding() async {
    final storage = ref.watch(secureStorageProvider);
    await storage.write(key: 'has_seen_onboarding', value: 'true');
    state = const AsyncValue.data(true);
  }
}
