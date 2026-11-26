import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../../../firebase_options.dart'; // El usuario debe generar este archivo

/// Top-level function para manejar notificaciones en background de FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");
}

const _kHabitRemindersChannelName = 'Recordatorios de Hábitos';

class NotificationRepository {
  static final NotificationRepository _instance = NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Inicializa Firebase y notificaciones locales
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      await _setupLocalNotifications();
      
      // Initialize timezone
      tz.initializeTimeZones();
      try {
        final locationInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(locationInfo.identifier));
      } catch (e) {
        tz.setLocalLocation(tz.getLocation('America/Bogota'));
      }

      await requestPermissions();
      _setupForegroundMessageHandlers();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint("Error inicializando NotificationRepository: $e");
    }
  }

  Future<void> _setupLocalNotifications() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
        
    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    if (Platform.isAndroid) {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'habitapp_high_importance_channel', // id
        _kHabitRemindersChannelName, // name
        description: 'Canal usado para notificaciones importantes de hábitos.',
        importance: Importance.max,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final androidImplementation = _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  void _setupForegroundMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'habitapp_high_importance_channel',
              _kHabitRemindersChannelName,
              channelDescription: 'Canal usado para notificaciones importantes de hábitos.',
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data['route'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data['route']);
    });
  }

  void _handleNotificationTap(String? payload) {
    // Aquí implementaremos la redirección al dashboard (AppRouter).
    debugPrint("Notification tapped with payload: $payload");
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'habitapp_high_importance_channel',
          _kHabitRemindersChannelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> scheduleHabitNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
    required int index, // Índice del recordatorio para evitar colisión si hay varios en el mismo día
  }) async {
    for (int day in daysOfWeek) {
      final scheduledDate = _nextInstanceOfTimeAndDay(hour, minute, day);

      // Generar un ID único por hábito, por día y por índice de recordatorio
      final uniqueId = (id.abs() % 10000) * 1000 + day * 100 + index;

      await _localNotificationsPlugin.zonedSchedule(
        id: uniqueId,

        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'habitapp_high_importance_channel',
            _kHabitRemindersChannelName,
            channelDescription: 'Recordatorios de hábitos',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelHabitNotifications(int habitId) async {
    // Cancelamos para los 7 días y hasta 10 posibles recordatorios por día (índices 0 a 9)
    for (int day = 1; day <= 7; day++) {
      for (int index = 0; index < 10; index++) {
        final uniqueId = (habitId.hashCode.abs() % 10000) * 1000 + day * 100 + index;
        await _localNotificationsPlugin.cancel(id: uniqueId);
      }
    }
  }

  Future<void> cancelAllPendingNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTimeAndDay(int hour, int minute, int dayOfWeek) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
