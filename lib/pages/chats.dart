import 'package:sparrow/components/chat.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = 'chats';
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final chatsController = Get.put((ChatsController()));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chatsController.getChats(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              return ListView.builder(
                itemCount: chatsController.chats.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (() {
                      Navigator.pushReplacementNamed(
                          context,
                          LandingScreen.routeName +
                              ChatsScreen.routeName +
                              chatsController.chats[index]["id"].toString());
                    }),
                    child: ChatCardComponent(
                        avatar: chatsController.chats[index]["avatar"],
                        name: chatsController.chats[index]["name"],
                        lastMsg: chatsController.chats[index]["lastMsg"],
                        lastMsgDate: chatsController.chats[index]
                            ["lastMsgDate"],
                        msgStatus: chatsController.chats[index]["msgStatus"]),
                  );
                },
              );

            default:
              return const Text('Problem While Featching Chats');
          }
        }));
  }
}
