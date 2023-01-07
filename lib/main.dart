// @dart=2.9
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/calls/calling_page.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/search.dart';
import 'package:sparrow/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userController = Get.put((UserController()));

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Let's Talk",
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        onGenerateRoute: (settings) =>
            genarateRoute(settings), // auto genarating routes
        home: LandingScreen(
          subRoute: 'chats',
        )); //
  }
}
