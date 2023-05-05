import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/utils/cache-manager.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool isInvalidCreds = false;
  @override
  void initState() {
    super.initState();
    // CacheStorage().removeAuthCards();
    // userController.user.value = {};

    Future.delayed(Duration.zero, () async {
      final authCards = await CacheStorage().getAuthCards();

      bool invalidCreds;
      try {
        invalidCreds = (authCards['refresh'].toString() ==
                '[This field may not be null.]' ||
            authCards['token'].toString() == '[This field may not be null.]');
      } catch (_) {
        invalidCreds = (authCards == null || authCards.isEmpty);
      }
      setState(() {
        isInvalidCreds = invalidCreds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      nextScreen: isInvalidCreds ? const AuthScreen() : const LandingScreen(),
      splashIconSize: 200,
      splash: Column(
        children: const [
          Image(
            image: AssetImage("assets/images/logo.png"),
            width: 120,
          ),
          SizedBox(height: 10),
          Text(
            'Lets Connect',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Made In India',
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
