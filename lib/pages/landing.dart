import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/pop-ups/createStatusPopup.dart';
import 'package:sparrow/components/status_view.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/statusController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/archivedChats.dart';
import 'package:sparrow/pages/calls.dart';
import 'package:sparrow/pages/conversation/chats.dart';
import 'package:sparrow/pages/usersFromContact.dart';
import 'package:sparrow/pages/settings/settingPage.dart';
import 'package:sparrow/pages/status.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/notification-api.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing/';
  // ignore: prefer_typing_uninitialized_variables
  final subRoute;
  const LandingScreen({super.key, this.subRoute = 'chats'});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final userController = Get.put(UserController());
  final chatsController = Get.put(ChatsController());
  final socketController = Get.put(SocketController());
  final statusController = Get.put(StatusController());

  bool isIncomingCall = false;

  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      final authCards = await CacheStorage().getAuthCards();
      userController.user.value = authCards['user'];
    });

    // Configuring user to Firebase
    FirebaseServices().requestPermission();
    FirebaseServices().getToken();

    SimpleWebSocket chatWS = socketController.chatWS_.value;

    chatWS.eventHandlers["chat.receive"] = (data) async {
      print(data);
      var senderName = await getUserNameFromMobile(data['senderMobile']);
      LocalNotificationService().showNotification(data['sender_id'], senderName,
          'Message: ${data['message']}', 'message notification');

      var senderConversationIndex = chatsController.chats.value.indexWhere(
          (chat) => chat['conv_mobile'].toString() == data['senderMobile']);

      chatsController.chats.value[senderConversationIndex]['last_message'] = {
        'message': data['message'],
        'status': data['status'],
        'timestamp': data['created_at'],
        'sender': data['sender']
      };
      chatsController.chats.refresh();
    };

    chatWS.eventHandlers["group.chat.receive"] = (data) async {
      print(data);
      var senderName = await getUserNameFromMobile(data['senderMobile']);
      var groupName = chatsController.chats
          .firstWhere((chat) => chat['id'] == data['group_id'])['group_name'];
      LocalNotificationService().showNotification(data['group_id'], groupName,
          '$senderName: ${data['message']}', 'message notification');

      var senderConversationIndex = chatsController.chats.value
          .indexWhere((chat) => chat['id'] == data['group_id']);

      chatsController.chats.value[senderConversationIndex]['last_message'] = {
        'message': data['message'],
        'status': data['status'],
        'timestamp': data['created_at'],
        'sender': data['sender'],
        'sender_id': data['sender_id']
      };
      chatsController.chats.refresh();
    };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.subRoute == ChatsScreen.routeName
          ? AppBar(
              elevation: 1,
              backgroundColor: const Color(0xfff2f2f2),
              centerTitle: true,
              title: const Text('Chats',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: AppColors.titleColor)),
              leading: const Icon(
                Icons.chat_bubble,
                color: Colors.grey,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, ArchivedChats.routeName),
                      child: const Icon(
                        Icons.edit_calendar_outlined,
                        color: Colors.blue,
                      )),
                ),
              ],
            )
          : widget.subRoute == StatusScreen.routeName
              ? AppBar(
                  elevation: 1,
                  backgroundColor: const Color(0xfff2f2f2),
                  centerTitle: true,
                  title: const Text('Status',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleColor)),
                  leading: const Icon(
                    Icons.donut_large,
                    color: Colors.grey,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateStatusPopup();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              : null,
      floatingActionButton: (widget.subRoute == ChatsScreen.routeName
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/landing/${ContactUsers.routeName}');
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            )
          : null),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/status.svg",
                          height: 26,
                          width: 26,
                          color: (widget.subRoute == 'status'
                              ? Colors.blue
                              : Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/landing/${StatusScreen.routeName}');
                        }),
                    Text('Status',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'status'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/chats.svg',
                        color: (widget.subRoute == 'chats'
                            ? Colors.blue
                            : Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/landing/${ChatsScreen.routeName}');
                      },
                    ),
                    Text('Chats',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'chats'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/calls.svg',
                          color: (widget.subRoute == 'calls'
                              ? Colors.blue
                              : Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/landing/${CallsScreen.routeName}');
                        }),
                    Text('Calls',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (widget.subRoute == 'calls'
                                ? Colors.blue
                                : Colors.grey)))
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/landing/${SettingPage.routeName}');
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      size: 35,
                      color: Color.fromARGB(255, 128, 128, 128),
                    ))
              ],
            ),
            if (widget.subRoute == ChatsScreen.routeName) ...{
              const Expanded(child: ChatsScreen())
            } else if (widget.subRoute == CallsScreen.routeName) ...{
              const Expanded(child: CallsScreen())
            } else if (widget.subRoute == StatusScreen.routeName) ...{
              const Expanded(child: StatusScreen())
            } else if (widget.subRoute == SettingPage.routeName) ...{
              const Expanded(child: SettingPage())
            } else if (widget.subRoute == ContactUsers.routeName) ...{
              const Expanded(child: ContactUsers())
            }
          ],
        ),
      ),
    );
  }
}
