import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/rtc/receiveCall.dart';
import 'package:sparrow/router.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/notification-api.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';

import 'locator.dart';

@pragma('vm:entry-point')
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(data, String route) {
    if (route == ReceiveCall.routeName) {
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) {
        return ReceiveCall(audioCall: false, offer_data: data);
      }));
    } else if (route == ChatRoomScreen.routeName) {
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) {
        return ChatRoomScreen(id: data['id']);
      }));
    } else if (route == GroupChatRoomScreen.routeName) {
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) {
        return GroupChatRoomScreen(id: data['id']);
      }));
    } else {
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) {
        return const LandingScreen(subRoute: 'chats');
      }));
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  var data = message.data;

  // if (data['type'] == 'notification.chat') {
  //   LocalNotificationService().showNotification(
  //       0, senderName, 'Message: ${data['body']}', 'message notification');
  // } else if (data['type'] == 'notification.group.chat') {
  //   LocalNotificationService().showNotification(0, data['group_name'],
  //       '$senderName: ${data['body']}', 'message notification');
  // } else if (data['type'] == 'notification.call') {
  //   LocalNotificationService()
  //       .showNotification(0, senderName, data['body'], 'message notification');
  // }

  if (data['type'] == 'notification.call') {
    await AudioPlayer().play(AssetSource("incomming-call.mp3"));
  }

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //   data = message.data;
  //   if (data['type'] == 'notification.chat') {
  //     _navigationService.navigateTo(data['context'], ChatRoomScreen.routeName);
  //   } else if (data['type'] == 'notification.group.chat') {
  //     _navigationService.navigateTo(
  //         data['context'], GroupChatRoomScreen.routeName);
  //   } else if (data['type'] == 'notification.call') {
  //     _navigationService.navigateTo(
  //         data['context']['offer_data'], ReceiveCall.routeName);
  //   }
  // });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: '.env');
  setupLocator();
  LocalNotificationService().setup();
  // Firebase messaging
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userController = Get.put((UserController()));
  final chatsController = Get.put((ChatsController()));
  final NavigationService _navigationService = locator<NavigationService>();

  SocketController socketController = Get.put((SocketController()));
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    // Channels
    SimpleWebSocket signallingWs = socketController.ws_.value;

    // Adding Event Handlers
    signallingWs.eventHandlers["rtc.offer"] = (data) async {
      _navigationService.navigateTo(data, ReceiveCall.routeName);
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Let's Talk",
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        onGenerateRoute: (settings) => genarateRoute(settings),
        home: const AuthScreen(),
        navigatorKey: locator<NavigationService>().navigatorKey);
  }
}
