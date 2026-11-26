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
import '../../features/auth/providers/splash_provider.dart';
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
import '../../features/community/presentation/screens/forum_detail_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/profile/providers/profile_provider.dart';

part 'app_router.g.dart';

const _kSplashPath = '/splash';
const _kOnboardingPath = '/onboarding';
const _kLoginPath = '/login';
const _kRegisterPath = '/register';
const _kLockPath = '/lock';
const _kCompleteProfilePath = '/complete-profile';

bool _isAuthOrGateLocation(String loc) {
  return loc == _kLoginPath ||
      loc == _kRegisterPath ||
      loc == _kSplashPath ||
      loc == _kOnboardingPath ||
      loc == _kLockPath;
}

bool _isProfileIncomplete(dynamic profile) {
  if (profile == null) return false;
  return profile.genero == null || profile.fechanacimiento == null;
}

bool _isLoadingAnyState(
  bool isSplashShowing,
  AsyncValue<bool> authState,
  AsyncValue<dynamic> onboardingState,
  AsyncValue<dynamic> biometricState,
) {
  return isSplashShowing ||
      authState.isLoading ||
      onboardingState.isLoading ||
      biometricState.isLoading;
}

String? _redirectIfMatching(String currentLoc, String targetLoc) {
  return currentLoc == targetLoc ? null : targetLoc;
}

String? _evaluateUnauthenticatedRedirect(String loc) {
  final canStayPublic = loc == _kLoginPath || loc == _kRegisterPath || loc == _kOnboardingPath;
  return canStayPublic ? null : _kOnboardingPath;
}

String? _evaluateAppRedirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authProvider);
  final onboardingState = ref.read(onboardingProvider);
  final biometricState = ref.read(biometricProvider);
  final isSplashShowing = ref.read(splashProvider);
  final loc = state.matchedLocation;

  if (_isLoadingAnyState(isSplashShowing, authState, onboardingState, biometricState)) {
    return _redirectIfMatching(loc, _kSplashPath);
  }

  if (!(authState.value ?? false)) {
    return _evaluateUnauthenticatedRedirect(loc);
  }

  if (biometricState.value?.isLocked ?? false) {
    return _redirectIfMatching(loc, _kLockPath);
  }

  final profile = ref.read(profileProvider).value;
  if (_isProfileIncomplete(profile)) {
    return _redirectIfMatching(loc, _kCompleteProfilePath);
  }

  if (_isAuthOrGateLocation(loc) || (loc == _kCompleteProfilePath && profile != null)) {
    return '/';
  }
  return null;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final listenable = _NotifierListenable(ref);

  return GoRouter(
    initialLocation: _kSplashPath,
    refreshListenable: listenable,
    routes: [
      GoRoute(
        path: _kSplashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: _kOnboardingPath,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: _kLoginPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: _kLockPath,
        builder: (context, state) => const LockScreen(),
      ),
      GoRoute(
        path: _kRegisterPath,
        builder: (context, state) => const RegisterScreen(),
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
                builder: (context, state) => const DashboardScreen(),
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
                builder: (context, state) => const Scaffold(),
              ),
            ],
          ),
          // Branch 3: Progreso / Reportes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) {
                  final userId = state.uri.queryParameters['userId'];
                  return ReportsScreen(userId: userId);
                },
              ),
            ],
          ),
          // Branch 4: Ajustes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
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
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/create-habit',
        builder: (context, state) => const CreateHabitScreen(),
      ),
      GoRoute(
        path: '/archived-habits',
        builder: (context, state) => const ArchivedHabitsScreen(),
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
      GoRoute(
        path: '/community/forum/:id',
        builder: (context, state) {
          final forumId = state.pathParameters['id']!;
          final title = state.extra as String? ?? 'Foro';
          return ForumDetailScreen(forumId: forumId, title: title);
        },
      ),
      GoRoute(
        path: _kCompleteProfilePath,
        builder: (context, state) => const CompleteProfileScreen(),
      ),
    ],
    redirect: (context, state) => _evaluateAppRedirect(ref, state),
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
    ref.listen(splashProvider, (prev, next) {
      if (prev != next) notifyListeners();
    });
    ref.listen(biometricProvider, (prev, next) {
      if (prev?.value?.isLocked != next.value?.isLocked) notifyListeners();
    });
    ref.listen(profileProvider, (prev, next) {
      if (prev?.value?.genero != next.value?.genero || prev?.value?.fechanacimiento != next.value?.fechanacimiento) {
        notifyListeners();
      }
    });
  }
}
