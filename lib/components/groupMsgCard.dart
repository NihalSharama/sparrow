import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/error-handlers.dart';

class GroupMsgCardComponent extends StatelessWidget {
  final String id;
  final String text;
  final DateTime time;
  final int from;
  final String? fromName;
  final bool isStarred;
  final String? replyOf;
  final Map? document;
  // ignore: prefer_typing_uninitialized_variables
  const GroupMsgCardComponent(
      {super.key,
      required this.text,
      required this.time,
      required this.from,
      required this.isStarred,
      required this.replyOf,
      required this.id,
      required this.document,
      required this.fromName});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final chatsController = Get.put(ChatsController());
    final socketController = Get.put(SocketController());
    final timestamp = isStarred
        ? DateFormat('dd/MM/yy').format(time)
        : DateFormat('h:mma').format(time);
    var replyOfObj = (replyOf == null ? null : json.decode(replyOf!));

    bool fromMe = from == userController.user['mobile'];
    return Column(
      crossAxisAlignment:
          (fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      children: [
        Card(
          color:
              (fromMe ? AppColors.myMsgCardColor : AppColors.thereMsgCardColor),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 2,
                  color: isStarred
                      ? Color.fromARGB(255, 206, 167, 218)
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
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!fromMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                      child: Text(
                        fromName!,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 227, 198, 255)),
                      ),
                    ),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                              color: AppColors.titleColorLight,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.file_present_rounded,
                                  color: Color.fromARGB(255, 199, 199, 199),
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
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    else
                                      Text(
                                          document!['document'].split('/')[
                                              document!['document']
                                                      .split('/')
                                                      .length -
                                                  1],
                                          style: const TextStyle(
                                              color: Colors.white))
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  BasicAppUtils().downloadFileFromUrl(
                                      '${dotenv.env['SERVER_MEDIA_URI']}${document!['document']}');
                                },
                                icon: const Icon(
                                  Icons.download,
                                  color: Color.fromARGB(255, 199, 199, 199),
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
                                        ? const Color.fromARGB(
                                            255, 219, 70, 245)
                                        : const Color.fromARGB(
                                            255, 78, 180, 170)),
                                    width: 3)),
                            // borderRadius: BorderRadius.circular(6),
                            color: Color.fromARGB(50, 14, 14, 14)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (replyOfObj!['replyTo_user'] ==
                                      userController.user['mobile']
                                  ? 'You'
                                  : replyOfObj!['replyTo_name']),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: (replyOfObj!['replyTo_user'] ==
                                          userController.user['mobile']
                                      ? const Color.fromARGB(255, 219, 70, 245)
                                      : const Color.fromARGB(
                                          255, 78, 180, 170))),
                            ),
                            Text(replyOfObj!['reply_message'],
                                style: const TextStyle(color: Colors.white)),
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
                                        ? const Color.fromARGB(
                                            255, 219, 70, 245)
                                        : const Color.fromARGB(
                                            255, 78, 180, 170)),
                                    width: 3)),
                            // borderRadius: BorderRadius.circular(6),
                            color: const Color.fromARGB(94, 231, 231, 231)),
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
                                      ? const Color.fromARGB(255, 219, 70, 245)
                                      : const Color.fromARGB(
                                          255, 78, 180, 170)),
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
                    constraints: BoxConstraints(minWidth: 50),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Text(
                            timestamp,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 8),
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
      ],
    );
  }
}
