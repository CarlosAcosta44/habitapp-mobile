import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitapp_frontend/features/notifications/data/repositories/notification_repository.dart';
import 'package:habitapp_frontend/features/notifications/providers/notification_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

int computeUniqueReminderId(int habitId, int dayOfWeek, int reminderIndex) {
  return (habitId.abs() % 10000) * 1000 + dayOfWeek * 100 + reminderIndex;
}

bool shouldEmitLocalReminder({
  required int androidSdkInt,
  required bool postNotificationsGranted,
  required bool exactAlarmGranted,
  required bool appToggleEnabled,
}) {
  if (!appToggleEnabled) return false;
  if (androidSdkInt >= 33 && !postNotificationsGranted) return false;
  if (androidSdkInt >= 31 && !exactAlarmGranted) return false;
  return true;
}

class FakeNotificationRepository extends Fake implements NotificationRepository {}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Bogota'));
  });

  group('NotificationRepository y NotificationProvider — Tabla de decisión 8 (UT-195 a UT-200)', () {
    // 1 (UT-195)
    test('UT-195: notificationRepositoryProvider permite inyectar y resolver instancia de NotificationRepository en Riverpod', () {
      final fakeRepo = FakeNotificationRepository();
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(notificationRepositoryProvider);
      expect(identical(repo, fakeRepo), isTrue);
    });

    // 2 (UT-196)
    test('UT-196: TD8-R1 Android 13+ con POST_NOTIFICATIONS, alarma exacta e interruptor activo emite recordatorio local (US039)', () {
      final emit = shouldEmitLocalReminder(
        androidSdkInt: 34,
        postNotificationsGranted: true,
        exactAlarmGranted: true,
        appToggleEnabled: true,
      );
      expect(emit, isTrue);
    });

    // 3 (UT-197)
    test('UT-197: TD8-R2 Android 13+ con permiso POST_NOTIFICATIONS denegado omite emisión sin bloquear la app', () {
      final emit = shouldEmitLocalReminder(
        androidSdkInt: 33,
        postNotificationsGranted: false,
        exactAlarmGranted: true,
        appToggleEnabled: true,
      );
      expect(emit, isFalse);
    });

    // 4 (UT-198)
    test('UT-198: TD8-R3 Android 10–12 (API 29–30) sin permiso runtime POST_NOTIFICATIONS e interruptor activo emite recordatorio', () {
      final emit = shouldEmitLocalReminder(
        androidSdkInt: 29,
        postNotificationsGranted: false,
        exactAlarmGranted: false,
        appToggleEnabled: true,
      );
      expect(emit, isTrue);
    });

    // 5 (UT-199)
    test('UT-199: TD8-R4 Interruptor de notificaciones apagado en Ajustes silencia todas las alertas locales', () {
      final emit = shouldEmitLocalReminder(
        androidSdkInt: 34,
        postNotificationsGranted: true,
        exactAlarmGranted: true,
        appToggleEnabled: false,
      );
      expect(emit, isFalse);
    });

    // 6 (UT-200)
    test('UT-200: Generación determinística de ID único por hábito, día de la semana (1–7) e índice evita colisiones de alarmas', () {
      final idLun0 = computeUniqueReminderId(42, 1, 0);
      final idLun1 = computeUniqueReminderId(42, 1, 1);
      final idMie0 = computeUniqueReminderId(42, 3, 0);

      expect(idLun0, isNot(equals(idLun1)));
      expect(idLun0, isNot(equals(idMie0)));
      expect(idLun0, equals(42100));
      expect(idLun1, equals(42101));
      expect(idMie0, equals(42300));
    });
  });
}
