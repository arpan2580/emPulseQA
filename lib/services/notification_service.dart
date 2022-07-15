import 'dart:convert';

import 'package:empulse/views/pages/feedback_comments.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';

import '../controllers/notification_controller.dart';
import '../views/pages/notification_page.dart';

class NotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    const ios = IOSInitializationSettings();
    const android = AndroidInitializationSettings("@mipmap/logo_empulse");
    const initializationSettings =
        InitializationSettings(android: android, iOS: ios);
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onClickNotification,
    );
  }

  Future<dynamic> onClickNotification(payload) async {
    payload = jsonDecode(payload);
    if (payload != '') {
      var id = payload['feedback_id'];
      var notificationId = payload['notification_id'];
      payload = '';
      NotificationController().readNotification(notificationId);
      Get.to(() => FeedbackComment(
            feedbackId: int.parse(id),
            isClose: false,
          ));
    } else {
      Get.to(
        () => const NotificationPage(),
      );
    }
  }

  static void requestPermission() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void showNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        await notificationDetails(),
        payload: jsonEncode(message.data),
      );
    } on Exception {
      // print(e);
    }
  }

  static Future notificationDetails() async {
    const notificationStyle = BigTextStyleInformation(
      '',
      htmlFormatTitle: true,
    );

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "fback",
        "fback_notificationchannel",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: notificationStyle,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
