import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  final userController = Get.put((UserController()));

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User Granted Provisional Permission');
    } else {
      print('User Declined or has not accepted permission');
    }
  }

  getToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    saveTokenToFirebase(token!);
  }

  saveTokenToFirebase(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(userController.user['mobile'].toString())
        .set({'token': token});
  }

  sendPushNotification(String mobile, String notificationType, String sender,
      Map context) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('UserTokens')
          .doc(mobile)
          .get();

      final token = snapshot['token'];

      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=${dotenv.env['FIREBASE_SERVER_KEY']!}'
              },
              body: json.encode({
                'priority': 'high',
                'data': {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'sound': notificationType == 'notification.call'
                      ? 'call_ringtone.mp3'
                      : 'default',
                  'type': notificationType,
                  'context': context
                },
                'notification': {
                  'android_channel_id':
                      'message notification', // there maybe phone number of reciever (for mute functionality)
                  'title': 'Sparrow',
                  'body': notificationType == 'notification.call'
                      ? 'Incomming ${context['audioCall'] ? 'Audio' : 'Video'} Call...'
                      : 'New Message Received',
                },
                'to': token
              }));

      print('notification sent: ' + response.statusCode.toString());
    } catch (e) {
      if (kDebugMode) {
        print('error while pushing notification: ${e.toString()}');
      }
    }
  }
}
