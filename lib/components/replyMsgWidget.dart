import 'package:sparrow/controllers/chatsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';

class ReplyMessageWidget extends StatelessWidget {
  ReplyMessageWidget({
    super.key,
  });

  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Container(
              color: Colors.green,
              width: 4,
            ),
            const SizedBox(width: 8),
            Expanded(child: buildReplyMessage()),
          ],
        ),
      );

  Widget buildReplyMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  chatsController.chatRoomDetails.value["group_name"] == null
                      ? chatsController.replyMessage.value['sender'] ==
                              userController.user['mobile']
                          ? 'You'
                          : chatsController.chatRoomDetails.value["conv_name"]
                      : chatsController.replyMessage.value['sender'] ==
                              userController.user['mobile']
                          ? 'You'
                          : chatsController.replyMessage.value['senderName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close, size: 16),
                onTap: () {
                  chatsController.replyMessage.value = {};
                },
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
              BasicAppUtils()
                  .utf8convert(chatsController.replyMessage.value['message']),
              style: const TextStyle(color: Colors.black54)),
        ],
      );
}
