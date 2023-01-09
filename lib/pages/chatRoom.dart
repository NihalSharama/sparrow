import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/retry.dart';
import 'package:sparrow/components/msgCard.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/calls/calling_page.dart';
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
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chatsController.getChatRoomDetails(widget.id),
        builder: (context, dynamic snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              return Obx(() {
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
                            const CircleAvatar(
                                maxRadius: 20,
                                minRadius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/chat_avatar.png')),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatsController
                                      .chatRoomDetails.value["conv_name"],
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
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, CallingPage.routeName);
                              },
                            ),
                            IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/calls.svg',
                                  color: Colors.blue,
                                ),
                                onPressed: () {}),
                            IconButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, CallingPage.routeName);
                                },
                                icon: const Icon(Icons.more_vert))
                          ],
                        ),
                      ),
                      Expanded(child: Obx(() {
                        return Material(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 246, 246, 246),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: chatsController
                                .chatRoomDetails.value['messages'].length,
                            itemBuilder: (context, index) {
                              final message = chatsController
                                  .chatRoomDetails.value["messages"][index];

                              return Align(
                                alignment: (message['sender'] ==
                                        userController.userId.value
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft),
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: MsgCardComponent(
                                        text: message['message'],
                                        time: DateTime.parse(
                                            message['created_at']),
                                        isStarred: message['isStarred'],
                                        msgStatus: message['status'],
                                        from: message['sender'])),
                              );
                            },
                          ),
                        );
                      })),
                      Material(
                        color: const Color.fromARGB(255, 246, 246, 246),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, bottom: 10, top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 246, 246, 246),
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
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: TextField(
                                            controller:
                                                chatsController.inputMsg.value,
                                            decoration: const InputDecoration(
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
                              GestureDetector(
                                onTap: (() {
                                  if (chatsController.inputMsg.value.text ==
                                      '') {
                                    return;
                                  }
                                  chatsController.onSendChatMsg();
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      shape: BoxShape.circle),
                                  child: const InkWell(
                                    child: (Icon(Icons.send_sharp,
                                        color: Colors.white, size: 18)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });

            default:
              return const Scaffold(
                  body: Center(child: Text('Problem While Featching Details')));
          }
        });
  }
}
