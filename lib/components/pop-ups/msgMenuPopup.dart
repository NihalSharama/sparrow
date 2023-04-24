import 'dart:convert';

import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';

class MsgMenuPopup extends StatefulWidget {
  final Map message;
  const MsgMenuPopup({super.key, required this.message});

  @override
  State<MsgMenuPopup> createState() => _MsgMenuPopupState();
}

class _MsgMenuPopupState extends State<MsgMenuPopup> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final socketController = Get.put(SocketController());
  @override
  Widget build(BuildContext context) {
    SimpleWebSocket chatWS = socketController.chatWS_.value;
    var message = widget.message;

    print(message);
    final isGroupChat = message['conversation'] == null;
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (message['sender'] == userController.user.value['mobile']) ...{
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  chatsController.onDeleteMsg(message['id'].toString());

                  if (isGroupChat) {
                    chatsController.chatRoomDetails.value['users']
                        .remove(userController.user.value['mobile']);
                    chatWS.send(json.encode({
                      "receivers_mobile":
                          chatsController.chatRoomDetails.value['users'],
                      "group_id": chatsController.chatRoomDetails.value['id'],
                      "event_type": "message.delete",
                      "message_id": message['id']
                    }));
                  } else {
                    chatWS.send(json.encode({
                      "receivers_mobile": [
                        chatsController.chatRoomDetails['receiver_info']
                            ['mobile']
                      ],
                      "event_type": "message.delete",
                      "message_id": message['id']
                    }));
                  }

                  // send msg_id to other member
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Unsend Message",
                      style: TextStyle(
                          color: AppColors.titleColorExtraLight,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.call_received,
                      color: AppColors.titleColorLight,
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.backgroundGrayLight,
              thickness: 1.2,
            ),
          },
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: message['message']));

                toasterSuccessMsg('Copied To Clipboard');

                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Copy Text",
                    style: TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.copy,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundGrayLight,
            thickness: 1.2,
          ),
          if (message['document'] != null) ...{
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () {
                  BasicAppUtils().downloadFileFromUrl(
                      '${dotenv.env['SERVER_MEDIA_URI']}${message['document']['document']}');
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Download File",
                      style: TextStyle(
                          color: AppColors.titleColorExtraLight,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.download,
                      color: AppColors.titleColorLight,
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.backgroundGrayLight,
              thickness: 1.2,
            ),
          },
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                chatsController.onStarUnstartMsg(message['id'].toString());

                if (isGroupChat) {
                  chatsController.chatRoomDetails.value['users']
                      .remove(userController.user.value['mobile']);
                  chatWS.send(json.encode({
                    "receivers_mobile":
                        chatsController.chatRoomDetails.value['users'],
                    "group_id": chatsController.chatRoomDetails.value['id'],
                    "event_type": "message.star",
                    "isStarred": message['isStarred'],
                    "message_id": message['id']
                  }));
                } else {
                  chatWS.send(json.encode({
                    "receivers_mobile": [
                      chatsController.chatRoomDetails['receiver_info']['mobile']
                    ],
                    "event_type": "message.star",
                    "isStarred": message['isStarred'],
                    "message_id": message['id']
                  }));
                }
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message['isStarred'] ? "Un-Star Message" : "Star Message",
                    style: const TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.star,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
