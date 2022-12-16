import 'package:client/pages/chatRoom.dart';
import 'package:client/pages/landing.dart';
import 'package:client/pages/auth.dart';
import 'package:flutter/material.dart';

Route<dynamic> genarateRoute(RouteSettings routeSettings) {
  final List<String> path = routeSettings.name!.split('/');

  if (routeSettings.name!.contains(LandingScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => LandingScreen(subRoute: path[2]),
    );
  } else if (routeSettings.name!.contains(ChatRoomScreen.routeName)) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => ChatRoomScreen(id: path[2]),
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
