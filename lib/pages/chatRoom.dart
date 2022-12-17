import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/msgCard.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/pages/chats.dart';
import 'package:sparrow/pages/landing.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = 'chat/';
  final String id;
  const ChatRoomScreen({super.key, required this.id});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final chatController = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: chatController.getChatRoomDetails(widget.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context,
                                LandingScreen.routeName +
                                    ChatsScreen.routeName);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                        CircleAvatar(
                            maxRadius: 20,
                            minRadius: 20,
                            backgroundImage: AssetImage(chatController
                                .chatRoomDetails.value["roomAvatar"])),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatController.chatRoomDetails.value["roomName"],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 61, 61, 61)),
                            ),
                            const Text(
                              'Tap here for contact info',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 87, 87, 87)),
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/video_call.svg',
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/calls.svg',
                              color: Colors.blue,
                            ),
                            onPressed: () {}),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.more_vert))
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: chatController
                          .chatRoomDetails.value['messages'].length,
                      itemBuilder: (context, index) {
                        final message = chatController
                            .chatRoomDetails.value["messages"][index];

                        return Align(
                          alignment: (message['from'] == 'you'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: MsgCardComponent(
                                  text: message['text'],
                                  time: '11:30',
                                  msgStatus: message['msgStatus'],
                                  from: message['from'])),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, bottom: 10, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35.0),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                    color: Colors.grey)
                              ],
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Type Something...",
                                          hintStyle: TextStyle(
                                              color: Colors.blueAccent),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.photo_camera,
                                      color: Colors.blueAccent),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.attach_file,
                                      color: Colors.blueAccent),
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: const BoxDecoration(
                              color: Colors.blueAccent, shape: BoxShape.circle),
                          child: InkWell(
                            child: const Icon(
                              Icons.keyboard_voice,
                              color: Colors.white,
                              size: 18,
                            ),
                            onLongPress: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );

          default:
            return const Text('Problem While Featching Details');
        }
      },
    );
  }
}
