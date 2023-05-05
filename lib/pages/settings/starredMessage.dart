import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/groupMsgCard.dart';
import 'package:sparrow/components/msgCard.dart';
import 'package:sparrow/components/pop-ups/msgMenuPopup.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../common/global_variables.dart';

class StarredMessage extends StatelessWidget {
  const StarredMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatsController = Get.put(ChatsController());

    return Obx(
      () {
        final starredMessages = chatsController
            .chatRoomDetails.value['messages']
            .where((message) => message['isStarred'] == true)
            .toList();

        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white60,
                ),
              ),
              title: const Text(
                "Starred Messages",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              backgroundColor: AppColors.appBarColor,
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (starredMessages.isEmpty || starredMessages == null) ...{
                  SvgPicture.asset(
                    "assets/icons/starred.svg",
                    height: 100,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "No Starred Messages",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  // ignore: equal_elements_in_set
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: const Text(
                      "Tap and hold on any message to star it, so you can easily find it later.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  )
                } else
                  Expanded(
                      child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 246, 246, 246),
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            itemCount: starredMessages.length,
                            itemBuilder: (context, index) {
                              final message = starredMessages[index];

                              return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return MsgMenuPopup(
                                            message: message,
                                          );
                                        },
                                      );
                                    },
                                    child: chatsController.chatRoomDetails
                                                .value['group_name'] ==
                                            null
                                        ? MsgCardComponent(
                                            id: message['id'].toString(),
                                            text: BasicAppUtils().utf8convert(
                                                message['message']),
                                            time: DateTime.parse(
                                                message['created_at']),
                                            isStarred: message['isStarred'],
                                            msgStatus: message['status'],
                                            from: message['sender'],
                                            document: message['document'],
                                            replyOf: message['replyOf'],
                                          )
                                        : GroupMsgCardComponent(
                                            id: message['id'].toString(),
                                            text: BasicAppUtils().utf8convert(
                                                message['message']),
                                            time: DateTime.parse(
                                                message['created_at']),
                                            isStarred: message['isStarred'],
                                            from: message['sender'],
                                            fromName: message['senderName'],
                                            document: message['document'],
                                            replyOf: message['replyOf'],
                                          ),
                                  ));
                            },
                          )))
              ],
            ));
      },
    );
  }
}
