import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_history.dart';

const AndroidNotificationChannel uehNotificationChannel = AndroidNotificationChannel(
  'ueh_student_alerts',
  'Thông báo UEH Student',
  description: 'Thông báo từ hệ thống UEH Student',
  importance: Importance.high,
);

UehNotification _toHistory(RemoteMessage message) {
  final title = message.notification?.title ??
      message.data['title']?.toString() ??
      'Thông báo UEH';
  final body = message.notification?.body ??
      message.data['body']?.toString() ??
      '';
  final received = message.sentTime ?? DateTime.now();
  // FCM messageId is stable across foreground, background and opened callbacks.
  final id = message.messageId ??
      '${received.microsecondsSinceEpoch}_${title.hashCode}_${body.hashCode}';
  return UehNotification(
    id: id,
    title: title,
    body: body,
    receivedAt: received,
    data: Map<String, dynamic>.from(message.data),
  );
}

/// Runs in a separate Android isolate. Never display local notifications here:
/// Android FCM already displays notification payloads while in the background.
@pragma('vm:entry-point')
Future<void> uehFirebaseBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationHistory.instance.save(_toHistory(message));
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  bool isReady = false;
  String? setupError;

  Future<void> initialize() async {
    if (!Platform.isAndroid) {
      setupError = 'Thông báo FCM trong bài tập được hỗ trợ trên Android.';
      return;
    }
    if (isReady) return;

    try {
      // FlutterFire CLI configures Android's google-services.json and Gradle
      // plugin. On Android this loads the default Firebase app from native
      // resources; missing configuration is handled without breaking Login.
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(uehFirebaseBackgroundHandler);

      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(uehNotificationChannel);

      _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
        unawaited(_onForeground(message));
      });
      _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((message) {
        unawaited(NotificationHistory.instance.save(_toHistory(message)));
      });
      final openedAtStart = await FirebaseMessaging.instance.getInitialMessage();
      if (openedAtStart != null) {
        await NotificationHistory.instance.save(_toHistory(openedAtStart));
      }

      isReady = true;
      setupError = null;
    } catch (error) {
      setupError =
          'Firebase chưa được liên kết với ứng dụng Android. Hãy chạy flutterfire configure và khởi động lại app.';
      isReady = false;
      // Do not log Firebase credentials or registration tokens.
      debugPrint('FCM initialization unavailable: ${error.runtimeType}');
    }
  }

  Future<AuthorizationStatus> requestPermission() async {
    if (!isReady) {
      throw StateError(setupError ?? 'Firebase chưa sẵn sàng.');
    }
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    return settings.authorizationStatus;
  }

  /// For a Firebase Console test only. Never log or commit device FCM tokens.
  Future<String?> getToken() async {
    if (!isReady) return null;
    return FirebaseMessaging.instance.getToken();
  }

  Future<void> _onForeground(RemoteMessage message) async {
    try {
      await NotificationHistory.instance.save(_toHistory(message));
      final title = message.notification?.title ??
          message.data['title']?.toString() ??
          'Thông báo UEH';
      final body = message.notification?.body ??
          message.data['body']?.toString() ??
          '';
      await _local.show(
        id: (message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString())
            .hashCode & 0x7fffffff,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            uehNotificationChannel.id,
            uehNotificationChannel.name,
            channelDescription: uehNotificationChannel.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (error) {
      debugPrint('Unable to display FCM message: ${error.runtimeType}');
    }
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
  }
}
