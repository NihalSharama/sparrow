import 'package:sparrow/components/CustomPopup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/chat.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';

class ChatsScreen extends StatefulWidget {
  static const routeName = 'chats';

  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final chatsController = Get.put(ChatsController());
  final callsController = Get.put(CallsController());
  final userController = Get.put(UserController());
  var isAddChat = false;

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
              return (chatsController.chats.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: Center(
                        child: Column(
                          children: const [
                            Text(
                              'No Conversation Found!',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.titleColorLight),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Click On Add Button To Get Started 😉',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.titleColorExtraLight),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Obx(
                      () => ListView.builder(
                        itemCount: chatsController.chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          final chat = chatsController.chats[index];
                          return GestureDetector(
                            onTap: () async {
                              if (chat['group_name'] != null) {
                                print(chat);
                                Navigator.pushNamed(context,
                                    '${GroupChatRoomScreen.routeName}${chat["id"]}');
                              } else {
                                Navigator.pushNamed(context,
                                    '${ChatRoomScreen.routeName}${chat["id"]}');
                              }
                            },
                            child: SingleChildScrollView(
                              child: Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        chatsController.onArchiveUnacrchiveMsg(
                                            chat,
                                            chat['conv_name'] != null,
                                            userController.user['id']);
                                      },
                                      backgroundColor: AppColors.mainColor,
                                      foregroundColor: Colors.white,
                                      icon: Icons.archive,
                                      label: 'Archive',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        if (chat['group_name'] != null) {
                                          chatsController.chats[index]['users']
                                              .remove(userController
                                                  .user['mobile']);

                                          await chatsController
                                              .changeGroupDetails({
                                            'users': chatsController
                                                .chats[index]['users'],
                                          }, chat['id'].toString());

                                          chatsController.chats.removeWhere(
                                              (element) =>
                                                  element['id'] == chat['id']);
                                        } else {
                                          chatsController.deleteConversation(
                                              chat['id'].toString());

                                          chatsController.chats.removeWhere(
                                              (element) =>
                                                  element['id'] == chat['id']);
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: chat['group_name'] != null
                                          ? Icons.exit_to_app
                                          : Icons.delete,
                                      label: chat['group_name'] != null
                                          ? 'Exit'
                                          : 'Delete',
                                    ),
                                  ],
                                ),
                                child: chat['group_name'] == null
                                    ? ChatCardComponent(
                                        avatar:
                                            '${dotenv.env['SERVER_MEDIA_URI']}${chat["avatar"]}',
                                        name: chat["conv_name"],
                                        lastMsg: chat["last_message"]
                                            ["message"],
                                        lastMsgDate: chat["last_message"]
                                            ["timestamp"],
                                        lastMsgSender: chat["last_message"]
                                                ["sender"]
                                            .toString(),
                                        msgStatus: chat["last_message"]
                                            ["status"])
                                    : ChatCardComponent(
                                        avatar:
                                            '${dotenv.env['SERVER_MEDIA_URI']}${chat["group_profile"]}',
                                        name: chat["group_name"],
                                        lastMsg: chat["last_message"]
                                            ["message"],
                                        lastMsgDate: chat["last_message"]
                                            ["timestamp"],
                                        lastMsgSender: chat["last_message"]
                                                ["sender"]
                                            .toString(),
                                        msgStatus: chat["last_message"]
                                            ["status"]),
                              ),
                            ),
                          );
                        },
                      ),
                    ));

            default:
              return const Text('Problem While Featching Chats');
          }
        }));
  }
}
