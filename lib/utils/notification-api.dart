import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = IOSInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('Notification: setup completed');
    }).catchError((Object error) {
      debugPrint('Notification Error: $error');
    });
  }

  Future<void> showNotification(
      int id, String title, String body, String channel) async {
    final androidDetail = AndroidNotificationDetails(channel, channel, channel);

    final iosDetail = IOSNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      noticeDetail,
    );
  }
}
