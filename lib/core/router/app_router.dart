import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/auth/providers/biometric_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/main_layout_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/habits/presentation/screens/create_habit_screen.dart';
import '../../features/habits/presentation/screens/habit_detail_screen.dart';
import '../../features/habits/presentation/screens/archived_habits_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/community/presentation/screens/challenges_screen.dart';
import '../../features/community/presentation/screens/challenge_detail_screen.dart';

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
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          // Branch 1: Comunidad
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityScreen(),
              ),
            ],
          ),
          // Branch 2: Añadir (Placeholder since button action is handled in BottomNavBar tap)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add',
                builder: (context, state) => Scaffold(),
              ),
            ],
          ),
          // Branch 3: Progreso / Reportes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => ReportsScreen(),
              ),
            ],
          ),
          // Branch 4: Ajustes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/habit/:id',
        builder: (context, state) {
          final habitId = state.pathParameters['id']!;
          return HabitDetailScreen(habitId: habitId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/create-habit',
        builder: (context, state) => CreateHabitScreen(),
      ),
      GoRoute(
        path: '/archived-habits',
        builder: (context, state) => ArchivedHabitsScreen(),
      ),
      GoRoute(
        path: '/community/challenge/:id',
        builder: (context, state) {
          final retoId = state.pathParameters['id']!;
          return ChallengeDetailScreen(retoId: retoId);
        },
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const ChallengesScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final onboardingState = ref.read(onboardingProvider);
      final biometricState = ref.read(biometricProvider);

      final loc = state.matchedLocation;
      final isAtSplash = loc == '/splash';
      final isAtOnboarding = loc == '/onboarding';
      final isAtLogin = loc == '/login';
      final isAtRegister = loc == '/register';
      final isAtLock = loc == '/lock';

      // 1. Mientras cargan los providers → mantener en Splash
      if (authState.isLoading || onboardingState.isLoading || biometricState.isLoading) {
        return isAtSplash ? null : '/splash';
      }

      // 2. Si no está autenticado → puede estar en onboarding, login o register. Por defecto va a onboarding.
      final isAuthenticated = authState.value ?? false;
      if (!isAuthenticated) {
        if (isAtLogin || isAtRegister || isAtOnboarding) return null;
        return '/onboarding'; // Pantalla de bienvenida
      }

      // 4. Si está autenticado pero la app está bloqueada
      final isLocked = biometricState.value?.isLocked ?? false;
      if (isAuthenticated && isLocked) {
        return isAtLock ? null : '/lock';
      }

      // 5. Si ya está autenticado y desbloqueado → no puede volver a pantallas de auth ni lock
      if (isAuthenticated && !isLocked && (isAtLogin || isAtRegister || isAtSplash || isAtOnboarding || isAtLock)) {
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
    ref.listen(biometricProvider, (prev, next) {
      if (prev?.value?.isLocked != next.value?.isLocked) notifyListeners();
    });
  }
}
