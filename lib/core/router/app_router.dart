import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Creamos un Listenable que notifique a GoRouter cuando el estado de autenticación cambie.
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
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Dashboard - (En construcción)'),
          ),
        ),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final onboardingState = ref.read(onboardingProvider);
      
      final isGoingToSplash = state.matchedLocation == '/splash';
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      // Si el estado está cargando, forzamos la pantalla de Splash
      if (authState.isLoading || onboardingState.isLoading) {
        return isGoingToSplash ? null : '/splash';
      }

      final hasSeenOnboarding = onboardingState.value ?? false;
      if (!hasSeenOnboarding) {
        return isGoingToOnboarding ? null : '/onboarding';
      }

      final isAuthenticated = authState.value ?? false;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Redirigir a login si no está autenticado e intenta ir a otra parte que no sea login
      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }

      // Redirigir al inicio si ya está autenticado e intenta ir al login o al splash/onboarding
      if (isAuthenticated && (isGoingToLogin || isGoingToSplash || isGoingToOnboarding)) {
        return '/';
      }

      return null;
    },
  );
}

/// Helper para convertir un Provider en un Listenable para el GoRouter
class _NotifierListenable extends ChangeNotifier {
  _NotifierListenable(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      if (previous?.value != next.value) {
        notifyListeners();
      }
    });
    ref.listen(onboardingProvider, (previous, next) {
      if (previous?.value != next.value) {
        notifyListeners();
      }
    });
  }
}
