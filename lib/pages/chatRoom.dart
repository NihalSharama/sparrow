import 'package:client/components/msgCard.dart';
import 'package:client/controllers/chatsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = '/chat/';
  final String id;
  const ChatRoomScreen({super.key, required this.id});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final chatController = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard_arrow_left, color: Colors.blue),
            CircleAvatar(
              minRadius: 30,
              maxRadius: 30,
              backgroundImage: AssetImage(
                  chatController.chatRoomDetails.value["roomAvatar"]),
            ),
            Column(
              children: [
                Text(
                  chatController.chatRoomDetails.value["roomName"],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 61, 61, 61)),
                ),
                const Text(
                  'tap here for contact info',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 87, 87, 87)),
                )
              ],
            ),
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/video_call.svg',
                  color: Colors.blue,
                ),
                onPressed: () {}),
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/calls.svg',
                  color: Colors.blue,
                ),
                onPressed: () {}),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final message =
                chatController.chatRoomDetails.value["messages"][index];

            return Align(
              alignment: (message.from == 'nihal'
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
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Type Something...",
                            hintStyle: TextStyle(color: Colors.blueAccent),
                            border: InputBorder.none),
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
                ),
                onLongPress: () {},
              ),
            )
          ],
        ),
      ],
    ));
  }
}
