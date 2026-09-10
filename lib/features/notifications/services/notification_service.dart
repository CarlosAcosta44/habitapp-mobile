import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../../../../firebase_options.dart'; // El usuario debe generar este archivo

/// Top-level function para manejar notificaciones en background de FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

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
      await requestPermissions();
      _setupForegroundMessageHandlers();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint("Error inicializando NotificationService: $e");
    }
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
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
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'habitapp_high_importance_channel', // id
        'Recordatorios de Hábitos', // name
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
              'Recordatorios de Hábitos',
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
          'Recordatorios de Hábitos',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
