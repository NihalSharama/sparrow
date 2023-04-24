import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/chat.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';

class ArchivedChats extends StatefulWidget {
  static const routeName = 'archived-messages';
  const ArchivedChats({super.key});

  @override
  State<ArchivedChats> createState() => _ArchivedChatsState();
}

class _ArchivedChatsState extends State<ArchivedChats> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var archivedChats = chatsController.archivedChats;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.appBarColor,
          centerTitle: true,
          title: const Text('Archived Messages',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            ),
          )),
      body: FutureBuilder(
          future: chatsController.getArchivedChats(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.done:
                return (archivedChats.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 300),
                        child: Center(
                          child: Column(
                            children: const [
                              Text(
                                'No Archived Chats Found!',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.titleColorLight),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Slide Left At Any Chat To Archive 😉',
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
                          itemCount: archivedChats.length,
                          itemBuilder: (BuildContext context, int index) {
                            final chat = archivedChats[index];
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
                                        padding: EdgeInsets.zero,
                                        onPressed: (context) {
                                          chatsController
                                              .onArchiveUnacrchiveMsg(
                                                  chat,
                                                  chat['conv_name'] != null,
                                                  userController.user['id']);
                                        },
                                        backgroundColor: AppColors.mainColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.archive,
                                        label: 'Un-Archive',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          if (chat['group_name'] != null) {
                                            archivedChats[index]['users']
                                                .remove(userController
                                                    .user['mobile']);

                                            await chatsController
                                                .changeGroupDetails({
                                              'users': archivedChats[index]
                                                  ['users']
                                            }, chat['id'].toString());

                                            archivedChats.removeWhere(
                                                (element) =>
                                                    element['id'] ==
                                                    chat['id']);
                                          } else {
                                            chatsController.deleteConversation(
                                                chat['id'].toString());

                                            archivedChats.removeWhere(
                                                (element) =>
                                                    element['id'] ==
                                                    chat['id']);
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
          })),
    );
  }
}
