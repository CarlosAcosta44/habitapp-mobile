import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final listenable = _NotifierListenable(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: listenable,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Crear cuenta — (En construcción)'),
          ),
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Dashboard — (En construcción)'),
          ),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final onboardingState = ref.read(onboardingProvider);

      final loc = state.matchedLocation;
      final isAtSplash = loc == '/splash';
      final isAtOnboarding = loc == '/onboarding';
      final isAtLogin = loc == '/login';
      final isAtRegister = loc == '/register';

      // 1. Mientras cargan los providers → mantener en Splash
      if (authState.isLoading || onboardingState.isLoading) {
        return isAtSplash ? null : '/splash';
      }

      // 2. Si NO vio el onboarding → siempre al onboarding
      final hasSeenOnboarding = onboardingState.value ?? false;
      if (!hasSeenOnboarding) {
        return isAtOnboarding ? null : '/onboarding';
      }

      // 3. Si no está autenticado → puede estar en login, register u onboarding
      //    (onboarding es accesible como "pantalla de atrás" desde login)
      final isAuthenticated = authState.value ?? false;
      if (!isAuthenticated) {
        if (isAtLogin || isAtRegister || isAtOnboarding) return null;
        return '/login';
      }

      // 4. Si ya está autenticado → no puede volver a pantallas de auth
      if (isAuthenticated && (isAtLogin || isAtRegister || isAtSplash || isAtOnboarding)) {
        return '/';
      }

      return null;
    },
  );
}

/// Puente Riverpod → GoRouter para que el router reaccione
/// a cambios de estado de autenticación y onboarding.
class _NotifierListenable extends ChangeNotifier {
  _NotifierListenable(Ref ref) {
    ref.listen(authProvider, (prev, next) {
      if (prev?.value != next.value) notifyListeners();
    });
    ref.listen(onboardingProvider, (prev, next) {
      if (prev?.value != next.value) notifyListeners();
    });
  }
}
