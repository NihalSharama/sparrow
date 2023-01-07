import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/pages/calls.dart';
import 'package:sparrow/pages/chats.dart';
import 'package:sparrow/pages/status.dart';
import 'package:sparrow/services/websockets.dart';
import 'package:sparrow/utils/cache-manager.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing/';
  // ignore: prefer_typing_uninitialized_variables
  final subRoute;
  const LandingScreen({super.key, this.subRoute = 'chats'});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final webSockets = WebSockets();
  final userController = Get.put(UserController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await webSockets.initWebSocketConnection();

      final authCards = await CacheStorage().getAuthCards();

      bool invalidCreds;
      try {
        invalidCreds = (authCards['refresh'].toString() ==
                '[This field may not be null.]' ||
            authCards['token'].toString() == '[This field may not be null.]');
        userController.userId.value =
            JwtDecoder.decode(authCards['token'])['user_id'];
      } catch (_) {
        invalidCreds = (authCards == null || authCards.isEmpty);
      }

      if (invalidCreds) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (widget.subRoute == ChatsScreen.routeName) ...{
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Edit',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
                  const Text('Chats',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.search_rounded,
                            size: 30,
                          ),
                        ),
                        Icon(Icons.edit_calendar_outlined)
                      ],
                    ),
                  ),
                ],
              )
            },
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/status.svg",
                          height: 26,
                          width: 26,
                          color: (widget.subRoute == 'status'
                              ? Colors.blue
                              : Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/landing/${StatusScreen.routeName}');
                        }),
                    Text('Status',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'status'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/chats.svg',
                        color: (widget.subRoute == 'chats'
                            ? Colors.blue
                            : Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/landing/${ChatsScreen.routeName}');
                      },
                    ),
                    Text('Chats',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'chats'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/calls.svg',
                          color: (widget.subRoute == 'calls'
                              ? Colors.blue
                              : Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/landing/${CallsScreen.routeName}');
                        }),
                    Text('Calls',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'calls'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await CacheStorage().removeAuthCards();

                      Navigator.pushReplacementNamed(
                          context, AuthScreen.routeName);
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 35,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ))
              ],
            ),
            if (widget.subRoute == ChatsScreen.routeName) ...{
              const Expanded(
                child: ChatsScreen(),
              )
            } else if (widget.subRoute == CallsScreen.routeName) ...{
              const Expanded(child: CallsScreen())
            } else if (widget.subRoute == StatusScreen.routeName) ...{
              const Expanded(child: StatusScreen())
            }
          ],
        ),
      ),
    );
  }
}
