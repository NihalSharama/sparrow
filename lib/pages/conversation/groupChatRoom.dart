import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/groupMsgCard.dart';
import 'package:sparrow/components/pop-ups/msgMenuPopup.dart';
import 'package:sparrow/components/replyMsgWidget.dart';
import 'package:sparrow/components/sendFileMsg.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/conversation/chatInfo.dart';
import 'package:sparrow/pages/conversation/chats.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/settings/starredMessage.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/notification-api.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:swipe_to/swipe_to.dart';

class GroupChatRoomScreen extends StatefulWidget {
  static const routeName = 'group/';
  final String id;
  const GroupChatRoomScreen({super.key, required this.id});

  @override
  State<GroupChatRoomScreen> createState() => _GroupChatRoomScreenState();
}

class _GroupChatRoomScreenState extends State<GroupChatRoomScreen> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final socketController = Get.put(SocketController());

  ScrollController scrollController = ScrollController();

  void initGroupChatListeners() {
    SimpleWebSocket chatWS = socketController.chatWS_.value;

    chatWS.eventHandlers["group.chat.receive"] = (data) async {
      // print(data);

      var senderName = await getUserNameFromMobile(data['senderMobile']);

      data['senderName'] = senderName;
      print(data);
      if (data['group_id'] == chatsController.chatRoomDetails.value['id']) {
        chatsController.chatRoomDetails.update(
            'messages',
            (value) =>
                [data] + chatsController.chatRoomDetails.value['messages']);
      } else {
        var groupName = chatsController.chats
            .firstWhere((chat) => chat['id'] == data['group_id'])['group_name'];
        LocalNotificationService().showNotification(data['group_id'], groupName,
            '$senderName: ${data['message']}', 'message notification');
      }
    };

    chatWS.eventHandlers["chat.receive"] = (data) async {
      print(data);

      var senderName = await getUserNameFromMobile(data['senderMobile']);
      print(senderName);
      LocalNotificationService().showNotification(data['sender_id'], senderName,
          'Message: ${data['message']}', 'message notification');
    };

    chatWS.eventHandlers["message.delete"] = (data) async {
      if (data['message_id'] != null &&
          data['group_id'] == chatsController.chatRoomDetails.value['id']) {
        print('message deleted: ' + data.toString());

        chatsController.chatRoomDetails['messages'].removeWhere((message) =>
            message['id'].toString() == data['message_id'].toString());

        chatsController.chatRoomDetails.update('messages',
            (_) => chatsController.chatRoomDetails.value['messages']);
      }
    };

    chatWS.eventHandlers["message.star"] = (data) async {
      if (data['message_id'] != null &&
          data['group_id'] == chatsController.chatRoomDetails.value['id']) {
        print('message starred state: ' + data.toString());

        var message = chatsController.chatRoomDetails['messages'].firstWhere(
            (message) =>
                message['id'].toString() == data['message_id'].toString());

        message['isStarred'] = data['isStarred'];

        chatsController.chatRoomDetails.update('messages',
            (_) => chatsController.chatRoomDetails.value['messages']);
      }
    };
  }

  @override
  Future<void> dispose() async {
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return FutureBuilder(
      future: chatsController.getGroupChatRoomDetails(widget.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));

          case ConnectionState.done:
            initGroupChatListeners();

            return Obx(() {
              var messages = chatsController.chatRoomDetails.value["messages"];
              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(11, 114, 102, 1)),
                      padding: const EdgeInsets.only(top: 40.0, bottom: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context,
                                        LandingScreen.routeName +
                                            ChatsScreen.routeName);
                                  },
                                  child: const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Color.fromARGB(255, 223, 223, 223),
                                    size: 35,
                                  ),
                                ),
                                SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        ChatRoomInfo.routeName + widget.id);
                                  },
                                  child: Row(
                                    children: [
                                      if (chatsController.chatRoomDetails[
                                              'group_profile'] ==
                                          null) ...{
                                        const CircleAvatar(
                                            maxRadius: 20,
                                            minRadius: 20,
                                            backgroundImage: AssetImage(
                                                'assets/images/default-group.jpg')),
                                      } else ...{
                                        CircleAvatar(
                                          // backgroundColor: Colors.amber,
                                          backgroundImage: NetworkImage(
                                              '${dotenv.env['SERVER_MEDIA_URI']}${chatsController.chatRoomDetails['group_profile']}'),
                                          radius: 20,
                                        )
                                      },
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chatsController
                                                        .chatRoomDetails[
                                                            'group_name']
                                                        .length >
                                                    25
                                                ? '${chatsController.chatRoomDetails['group_name'].substring(0, 25)}...'
                                                : chatsController
                                                        .chatRoomDetails[
                                                    'group_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                          const Text(
                                            'Tap here for group info',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // IconButton(
                                //   icon: SvgPicture.asset(
                                //     'assets/icons/video_call.svg',
                                //     color: Colors.blue,
                                //   ),
                                //   onPressed: () {
                                //     var recvMobileNo = chatsController
                                //         .chatRoomDetails
                                //         .value["receiver_info"]["mobile"]
                                //         .toString();

                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => CallScreen(
                                //                   recvMobile: recvMobileNo,
                                //                   audioCall: false,
                                //                 )));
                                //   },
                                // ),
                                // IconButton(
                                //     icon: SvgPicture.asset(
                                //       'assets/icons/calls.svg',
                                //       color: Colors.blue,
                                //     ),
                                //     onPressed: () {
                                //       var recvMobileNo = chatsController
                                //           .chatRoomDetails
                                //           .value["receiver_info"]["mobile"]
                                //           .toString();

                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => CallScreen(
                                //                     recvMobile: recvMobileNo,
                                //                     audioCall: true,
                                //                   )));
                                //     }),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPopup(
                                              elements: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const StarredMessage()));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        "Starred Messages",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .titleColorExtraLight,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Colors.yellowAccent,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Divider(
                                                color: AppColors
                                                    .backgroundGrayLight,
                                                thickness: 1.2,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomPopup(
                                                              elements: Column(
                                                            children: [
                                                              Text(
                                                                'Are you Sure do you want to exit the group \n  You may have some memories with it ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange
                                                                        .shade700),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              CustomButton(
                                                                onPressed:
                                                                    () async {
                                                                  chatsController
                                                                      .chatRoomDetails
                                                                      .value[
                                                                          'users']
                                                                      .remove(userController
                                                                              .user[
                                                                          'mobile']);
                                                                  await chatsController.changeGroupDetails(
                                                                      {
                                                                        'users': chatsController
                                                                            .chatRoomDetails
                                                                            .value['users']
                                                                      },
                                                                      chatsController
                                                                          .chatRoomDetails[
                                                                              'id']
                                                                          .toString());

                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator.pushReplacementNamed(
                                                                      context,
                                                                      LandingScreen
                                                                              .routeName +
                                                                          ChatsScreen
                                                                              .routeName);
                                                                },
                                                                text: 'Exit',
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            ],
                                                          ));
                                                        });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Exit Group",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .titleColorExtraLight,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Icon(
                                                        Icons.exit_to_app,
                                                        color:
                                                            Colors.red.shade400,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ));
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    if (messages.length == 0 || messages == null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'No Messages Sent!',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.titleColorLight),
                              ),
                              Text(
                                'Say Hi To Start A Lovely Conversation 😉',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.titleColorExtraLight),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                          child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color.fromARGB(255, 246, 246, 246),
                              child: (ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index];

                                  return SwipeTo(
                                    onRightSwipe: () {
                                      chatsController.replyMessage.value =
                                          message;

                                      focusNode.requestFocus();
                                    },
                                    child: Padding(
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
                                          child: GroupMsgCardComponent(
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
                                        )),
                                  );
                                },
                              )))),
                    Material(
                      color: const Color.fromARGB(255, 246, 246, 246),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, bottom: 10, top: 5),
                        child: Column(
                          children: [
                            if (chatsController.replyMessage.value.isNotEmpty)
                              buildReply()
                            else if (chatsController
                                .selectedFilePath.value.isNotEmpty)
                              buildSendFile(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          200, 231, 229, 1),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: TextField(
                                              focusNode: focusNode,
                                              controller: chatsController
                                                  .inputMsg.value,
                                              decoration: const InputDecoration(
                                                hintText: "Type Something...",
                                                hintStyle: TextStyle(
                                                    color: AppColors
                                                        .titleColorLight,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.photo_camera,
                                              color: AppColors
                                                  .titleColorExtraLight),
                                          onPressed: () async {
                                            await chatsController.clickPhoto();

                                            focusNode.requestFocus();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.attach_file,
                                              color: AppColors
                                                  .titleColorExtraLight),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomPopup(
                                                    elements: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          chatsController
                                                              .selectPhoto();

                                                          Navigator.pop(
                                                              context);
                                                          focusNode
                                                              .requestFocus();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              "Select Image",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .titleColorExtraLight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Icon(
                                                              Icons.photo,
                                                              color: AppColors
                                                                  .titleColorLight,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      color: AppColors
                                                          .backgroundGrayLight,
                                                      thickness: 1.2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          chatsController
                                                              .selectDocument();
                                                          Navigator.pop(
                                                              context);
                                                          focusNode
                                                              .requestFocus();
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Text(
                                                              "Select Document",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .titleColorExtraLight,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Icon(
                                                              Icons
                                                                  .file_present_rounded,
                                                              color: AppColors
                                                                  .titleColorLight,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                              },
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    chatsController
                                        .onSendGroupChat(userController
                                            .user['mobile']
                                            .toString())
                                        .then((value) {
                                      if (value.containsKey("success")) {
                                        bool success = value["success"];
                                        if (success) {
                                          chatsController.replyMessage.value =
                                              {};
                                          SimpleWebSocket chatWS =
                                              socketController.chatWS_.value;

                                          if (value.containsKey("data")) {
                                            var message = value['data'];

                                            chatWS.send(json.encode(message));

                                            // ignore: non_constant_identifier_names
                                            for (var receiver_mobile in message[
                                                'receivers_mobile']) {
                                              FirebaseServices()
                                                  .sendPushNotification(
                                                      receiver_mobile
                                                          .toString(),
                                                      'notification.group.chat',
                                                      userController
                                                          .user['mobile']
                                                          .toString(),
                                                      {
                                                    'id': chatsController
                                                        .chatRoomDetails
                                                        .value['id']
                                                        .toString()
                                                  });
                                            }
                                          }
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(11, 114, 102, 1),
                                        shape: BoxShape.circle),
                                    child: const InkWell(
                                      child: (Icon(Icons.send_sharp,
                                          color: Colors.white, size: 18)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });

          default:
            return const Scaffold(body: Text('Failed To Fetch Details'));
        }
      },
    );
  }

  Widget buildReply() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ReplyMessageWidget(),
      );

  Widget buildSendFile() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SendFileMessageWidget(),
      );
}
