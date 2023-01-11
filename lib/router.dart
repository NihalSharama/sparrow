import 'package:sparrow/pages/calls/calling_page.dart';
import 'package:sparrow/pages/chatRoom.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:flutter/material.dart';

Route<dynamic> genarateRoute(RouteSettings routeSettings) {
  final List<String> path = routeSettings.name!.split('/');

  print('path: $path');

  if (routeSettings.name!.contains(LandingScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => LandingScreen(subRoute: path[2]),
    );
  } else if (routeSettings.name!.contains(ChatRoomScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ChatRoomScreen(id: path[1]),
    );
  } else if (routeSettings.name!.contains(CallingPage.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => CallingPage(isVideoCall: path[1] == 'video'),
    );
  }

  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return PageRouteBuilder(
        settings: routeSettings,
        pageBuilder: (_, __, ___) => const AuthScreen(),
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
