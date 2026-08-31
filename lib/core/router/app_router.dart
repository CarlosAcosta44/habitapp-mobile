import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Creamos un Listenable que notifique a GoRouter cuando el estado de autenticación cambie.
  final listenable = _NotifierListenable(ref);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: listenable,
    routes: [
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

      // Si el estado está cargando, mantenemos al usuario donde está hasta que resuelva
      if (authState.isLoading) return null;

      final isAuthenticated = authState.value ?? false;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Redirigir a login si no está autenticado e intenta ir a otra parte
      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }

      // Redirigir al inicio si ya está autenticado e intenta ir al login
      if (isAuthenticated && isGoingToLogin) {
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
      // Solo notificamos al Router si el valor real (bool) cambió, ignorando estados de loading si no cambian el resultado.
      if (previous?.value != next.value) {
        notifyListeners();
      }
    });
  }
}
