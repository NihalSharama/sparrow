import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:path/path.dart' as path;
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MsgCardComponent extends StatelessWidget {
  final String id;
  final String text;
  final DateTime time;
  final String msgStatus;
  final int from;
  final bool isStarred;
  final String? replyOf;
  final Map? document;
  // ignore: prefer_typing_uninitialized_variables
  const MsgCardComponent(
      {super.key,
      required this.text,
      required this.time,
      required this.msgStatus,
      required this.from,
      required this.isStarred,
      this.replyOf,
      required this.id,
      this.document});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final chatsController = Get.put(ChatsController());
    final socketController = Get.put(SocketController());
    final timestamp = DateFormat('h:mma').format(time);
    var replyOfObj = (replyOf == null ? null : json.decode(replyOf!));

    bool fromMe = from == userController.user['mobile'];

    return Column(
      crossAxisAlignment:
          (fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      children: [
        VisibilityDetector(
          onVisibilityChanged: (visibilityInfo) {
            bool isVisible = visibilityInfo.visibleFraction == 1;
            if (isVisible &&
                msgStatus == 'sent' &&
                from != userController.user['mobile']) {
              chatsController.onMsgStatusChanged(id, 'seen');
              SimpleWebSocket chatWS = socketController.chatWS_.value;

              chatWS.send(json.encode({
                "receivers_mobile": [
                  chatsController.chatRoomDetails['receiver_info']['mobile']
                ],
                "event_type": "message.status",
                "status": "seen",
                "message_id": id
              }));
            }
          },
          key: Key(id),
          child: Card(
            color: (fromMe
                ? const Color.fromARGB(255, 231, 255, 211)
                : const Color.fromARGB(255, 255, 255, 255)),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 2,
                    color: isStarred
                        ? Color.fromARGB(255, 184, 223, 220)
                        : Colors.transparent),
                borderRadius: (fromMe
                    ? const BorderRadius.only(
                        topRight: Radius.circular(0),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)))),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (document != null) ...{
                      if (document!['document'].contains('/images/'))
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPopup(
                                    elements: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                    ClipboardData(text: text));

                                                toasterSuccessMsg(
                                                    'Copied To Clipboard');

                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.copy,
                                                color:
                                                    AppColors.titleColorLight,
                                              )),
                                          IconButton(
                                            onPressed: () {
                                              BasicAppUtils().downloadFileFromUrl(
                                                  '${dotenv.env['SERVER_MEDIA_URI']}${document!['document']}');
                                            },
                                            icon: const Icon(
                                              Icons.download,
                                              color: AppColors.titleColorLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            '${dotenv.env['SERVER_MEDIA_URI']}${document!['document']}')),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        text,
                                        style: const TextStyle(
                                            color: (Color.fromARGB(
                                                255, 43, 43, 43))),
                                      ),
                                    ),
                                  ],
                                ));
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Image(
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    '${dotenv.env['SERVER_MEDIA_URI']}${document!['document']}')),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(4),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.file_present_rounded,
                                    color: AppColors.titleColorLight,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    children: [
                                      if (document!['document']
                                              .split('/')[document!['document']
                                                      .split('/')
                                                      .length -
                                                  1]
                                              .length >
                                          20)
                                        Text(
                                          document!['document']
                                                  .split('/')[
                                                      document!['document']
                                                              .split('/')
                                                              .length -
                                                          1]
                                                  .substring(0, 20) +
                                              '...',
                                          style: TextStyle(
                                              color: Colors.grey.shade900),
                                        )
                                      else
                                        Text(
                                            document!['document'].split('/')[
                                                document!['document']
                                                        .split('/')
                                                        .length -
                                                    1],
                                            style: TextStyle(
                                                color: Colors.grey.shade900))
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    BasicAppUtils().downloadFileFromUrl(
                                        '${dotenv.env['SERVER_MEDIA_URI']}${document!['document']}');
                                  },
                                  icon: Icon(
                                    Icons.download,
                                    color: Colors.grey.shade800,
                                  ))
                            ],
                          ),
                        )
                    },
                    if (replyOfObj != null) ...{
                      if (replyOfObj!['reply_type'] == 'reply.chat')
                        Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 8, right: 40),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: (replyOfObj!['replyTo_user'] ==
                                              userController.user['mobile']
                                          ? Colors.purple
                                          : const Color.fromARGB(
                                              255, 0, 150, 135)),
                                      width: 3)),
                              // borderRadius: BorderRadius.circular(6),
                              color: Color.fromARGB(94, 231, 231, 231)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (replyOfObj!['replyTo_user'] ==
                                        userController.user['mobile']
                                    ? 'You'
                                    : chatsController
                                        .chatRoomDetails.value["conv_name"]),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (replyOfObj!['replyTo_user'] ==
                                            userController.user['mobile']
                                        ? Colors.purple
                                        : Color.fromARGB(255, 0, 150, 135))),
                              ),
                              Text(
                                  BasicAppUtils().utf8convert(
                                      replyOfObj!['reply_message']),
                                  style:
                                      const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                      if (replyOfObj!['reply_type'] == 'reply.status') ...{
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: (replyOfObj!['replyTo_user'] ==
                                              userController.user['mobile']
                                          ? Colors.purple
                                          : const Color.fromARGB(
                                              255, 0, 150, 135)),
                                      width: 3)),
                              // borderRadius: BorderRadius.circular(6),
                              color: Color.fromARGB(94, 231, 231, 231)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (path
                                  .extension(replyOfObj!['reply_status'])
                                  .isImageFileName)
                                Image(
                                    height: 40,
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        '${dotenv.env['SERVER_MEDIA_URI']}${replyOfObj!['reply_status']}'))
                              else
                                const Image(
                                  height: 40,
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage("assets/icons/play-video.png"),
                                ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Status'),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/status.svg",
                                    height: 15,
                                    width: 15,
                                    color: (replyOfObj!['replyTo_user'] ==
                                            userController.user['mobile']
                                        ? Colors.purple
                                        : const Color.fromARGB(
                                            255, 0, 150, 135)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      },
                      const SizedBox(height: 4)
                    },
                    Container(
                      constraints: BoxConstraints(minWidth: 60),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                            ),
                            child: Text(
                              text,
                              maxLines: 5,
                              style: const TextStyle(
                                  color: (Color.fromARGB(255, 43, 43, 43))),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  timestamp,
                                  style: const TextStyle(
                                      color: (Color.fromARGB(255, 43, 43, 43)),
                                      fontSize: 8),
                                ),
                                if (fromMe) ...{
                                  const SizedBox(width: 8),
                                  if (msgStatus == 'sent') ...{
                                    const Icon(
                                      Icons.done,
                                      color: Colors.grey,
                                      size: 12,
                                    )
                                  }
                                  // else if (msgStatus == 'delivered') ...{
                                  //   const Icon(
                                  //     Icons.done_all,
                                  //     color: Colors.grey,
                                  //     size: 14,
                                  //   )
                                  // }
                                  else ...{
                                    const Icon(
                                      Icons.done_all,
                                      color: Colors.blue,
                                      size: 12,
                                    )
                                  },
                                },
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
