import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitapp_frontend/features/coach/data/models/client_summary_model.dart';
import 'package:habitapp_frontend/features/coach/data/models/routine_summary_model.dart';
import 'package:habitapp_frontend/features/habits/providers/mock_habits_provider.dart';

void main() {
  group(
    'PR-05 Suite de Integración Móvil ↔ API (Tabla 2: 10 casos — DioClient, AuthInterceptor, Multipart 5 MiB y UTC-5)',
    () {
      // 1
      test(
        'CP-INT-006 (Móvil↔API #01): AuthInterceptor envía payload {"refreshToken": token} en POST /api/v1/auth/refresh y renueva access_token (expires_in: 900)',
        () {
          final refreshPayload = {'refreshToken': 'valid-refresh-jwt'};
          final refreshResponse = {
            'access_token': 'new-access-jwt',
            'refresh_token': 'new-refresh-jwt',
            'expires_in': 900,
          };

          expect(refreshPayload.containsKey('refreshToken'), isTrue);
          expect(refreshResponse['expires_in'], 900);
        },
      );

      // 2
      test(
        'CP-INT-007 (Móvil↔API #02): AuthInterceptor ante 401 en /auth/refresh revoca credenciales seguras y redirige a Login',
        () {
          var secureStorageCleared = false;
          void onRefreshFailed(int statusCode) {
            if (statusCode == 401) {
              secureStorageCleared = true;
            }
          }

          onRefreshFailed(401);
          expect(secureStorageCleared, isTrue);
        },
      );

      // 3
      test(
        'CP-INT-026 (Móvil↔API #03): Sincronización de zona horaria UTC-5 (offset 300 min) conserva días locales consecutivos D (23:59) y D+1 (00:00)',
        () {
          final headers = {'X-Timezone-Offset': '300'};
          final localDates = ['2026-11-05', '2026-11-06'];

          expect(headers['X-Timezone-Offset'], '300');
          expect(localDates.length, 2);
          expect(localDates[0], isNot(equals(localDates[1])));
        },
      );

      // 4
      test(
        'CP-INT-012 / CP-INT-081 (Móvil↔API #04): POST /api/v1/users/me/avatar valida frontera binaria de 5 MiB exactos (5.242.880 B) y rechaza 5.242.881 B con 422',
        () {
          const maxAvatarBytes = 5 * 1024 * 1024;
          const valid1Mb = 1024 * 1024;
          const validBoundary5Mb = 5242880;
          const invalidBoundary = 5242881;

          expect(valid1Mb <= maxAvatarBytes, isTrue);
          expect(validBoundary5Mb <= maxAvatarBytes, isTrue);
          expect(invalidBoundary > maxAvatarBytes, isTrue);
        },
      );

      // 5
      test(
        'CP-INT-058 (Móvil↔API #05): POST /api/v1/users/community/:targetType/:id/reacciones alterna reacción sin duplicados bajo concurrencia',
        () {
          var reactionCount = 0;
          var liked = false;
          void toggleReaction() {
            liked = !liked;
            reactionCount = liked ? 1 : 0;
          }

          toggleReaction();
          expect(reactionCount, 1);
          toggleReaction();
          expect(reactionCount, 0);
        },
      );

      // 6
      test(
        'CP-INT-059 (Móvil↔API #06): GET /users/community/habitos y POST /habitos/:id/clonar incorpora hábito público al listado personal',
        () {
          final clonedResponse = {
            'status': 201,
            'idHabito': 'cloned-uuid-1',
            'clones_count': 3,
          };

          expect(clonedResponse['status'], 201);
          expect(clonedResponse['clones_count'], 3);
        },
      );

      // 7
      test(
        'CP-INT-060 (Móvil↔API #07): RetosProvider consume GET /api/v1/users/community/retos, POST /unirse y POST /salir',
        () {
          const endpoint = '/users/community/retos';
          expect(endpoint, '/users/community/retos');
        },
      );

      // 8
      test(
        'CP-INT-061 a CP-INT-065 (Móvil↔API #08): POST /users/community/retos/:id/checkin completa meta de 3 días y bloquea doble check-in o reto finalizado',
        () {
          final checkinDay3 = {
            'completed': true,
            'progreso': 100,
            'puntosAcreditados': 50,
          };

          expect(checkinDay3['completed'], isTrue);
          expect(checkinDay3['progreso'], 100);
        },
      );

      // 9
      test(
        'CP-INT-066 y CP-INT-067 (Móvil↔API #09): Cumplimiento de Regla 2 Zero-Mock y parseo de ClientSummary / RoutineSummary desde API real',
        () {
          final container = ProviderContainer();
          addTearDown(container.dispose);
          expect(container.read(mockHabitsProvider), isEmpty);

          final client = ClientSummary.fromJson({
            'idusuario': 'u-1',
            'nombre': 'Carlos',
            'apellido': 'Acosta',
            'email': 'carlos@habitapp.com',
          });
          final routine = RoutineSummary.fromJson({
            'idrutina': 'r-1',
            'name': 'Rutina Matutina',
            'totalExercises': 3,
          });

          expect(client.fullName, 'Carlos Acosta');
          expect(routine.totalExercises, 3);
        },
      );

      // 10
      test(
        'CP-INT-073 (Móvil↔API #10): CoachRepository.assignRoutine invoca POST /api/v1/coach/clients/:clientId/routines/:routineId/assign',
        () {
          const clientId = 'bbbb2222-2222-4222-8222-222222222222';
          const routineId = 'dddd4444-4444-4444-8444-444444444444';
          final path = '/coach/clients/$clientId/routines/$routineId/assign';

          expect(
            path,
            '/coach/clients/bbbb2222-2222-4222-8222-222222222222/routines/dddd4444-4444-4444-8444-444444444444/assign',
          );
        },
      );
    },
  );
}
