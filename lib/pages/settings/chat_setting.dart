import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/settingWidget.dart';
import 'package:flutter/material.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/utils/error-handlers.dart';

class ChatSetting extends StatefulWidget {
  const ChatSetting({super.key});

  @override
  State<ChatSetting> createState() => _ChatSettingState();
}

class _ChatSettingState extends State<ChatSetting> {
  final chatsController = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: const Text(
          "Chats",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const SettingWidget2(title: "Change Wallpaper"),
          const SizedBox(
            height: 20,
          ),
          // SettingWidgetWithButton(title: "Save to Camera Roll"),
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "Automatically save photos and videos you receive to your iPhone’s Camera Roll.",
          //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // SettingWidget2(title: "Chat Backup"),
          // const SizedBox(
          //   height: 30,
          // ),
          NormalTextSetting(
            title: "Archive All Chats",
            color: Colors.blue,
            onTap: () {},
          ),
          Container(
            color: Colors.white,
            child: const Divider(
              thickness: 1,
              height: 1,
            ),
          ),

          NormalTextSetting(
            title: "Delete All Chats",
            onTap: () {
              Fluttertoast.showToast(
                msg: 'It may take time',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.orange,
              );
              for (var chat in chatsController.chats.value) {
                if (chat['conv_mobile'] != null) {
                  chatsController.deleteConversation(chat['id'].toString());
                } else {
                  chatsController.deleteGroup(chat['id'].toString());
                }
              }

              toasterSuccessMsg('Deleted All Chats');
            },
          ),
        ],
      ),
    );
  }
}
