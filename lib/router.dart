import 'package:sparrow/main.dart';
import 'package:sparrow/pages/archivedChats.dart';
import 'package:sparrow/pages/conversation/chatInfo.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:sparrow/pages/rtc/receiveCall.dart';
import 'package:sparrow/pages/usersFromContact.dart';

class ReceiveCallArgs {
  final bool audioCall;
  final Map offer_data;

  ReceiveCallArgs(this.audioCall, this.offer_data);
}

Route<dynamic> genarateRoute(RouteSettings routeSettings) {
  final List<String> path = routeSettings.name!.split('/');

  if (routeSettings.name!.contains(LandingScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => const LandingScreen(),
    );
  } else if (routeSettings.name!.contains(GroupChatRoomScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => GroupChatRoomScreen(id: path[1]),
    );
  } else if (routeSettings.name!.contains(ChatRoomScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ChatRoomScreen(id: path[1]),
    );
  } else if (routeSettings.name!.contains(ChatRoomInfo.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ChatRoomInfo(id: path[1]),
    );
  }

  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (_, __, ___) => const AuthScreen(),
      );
    case ArchivedChats.routeName:
      return PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (_, __, ___) => const ArchivedChats(),
      );
    case ContactUsers.routeName:
      return PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (_, __, ___) => const ContactUsers(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
