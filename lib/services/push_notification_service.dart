import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize notifications (call from main.dart)
  Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔔 Notification permission granted');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleMessage(message);
      });

      // Handle background & terminated messages
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message);
      });

      // Optional: Print token (useful for targeted notifications)
      String? token = await _firebaseMessaging.getToken();
      print('📱 FCM Token: $token');
    } else {
      print('🚫 Notification permission denied');
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification != null) {
      debugPrint('🔔 Notification Title: ${message.notification!.title}');
      debugPrint('📩 Notification Body: ${message.notification!.body}');
    }
  }
}
