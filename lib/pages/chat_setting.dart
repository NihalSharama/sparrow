import 'package:flutter/material.dart';
import 'package:sparrow/components/setting_widget.dart';

class ChatSetting extends StatefulWidget {
  const ChatSetting({super.key});

  @override
  State<ChatSetting> createState() => _ChatSettingState();
}

class _ChatSettingState extends State<ChatSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: Text(
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
          SettingWidget2(title: "Change Wallpaper"),
          const SizedBox(
            height: 20,
          ),
          SettingWidgetWithButton(title: "Save to Camera Roll"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Automatically save photos and videos you receive to your iPhone’s Camera Roll.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SettingWidget2(title: "Chat Backup"),
          const SizedBox(
            height: 30,
          ),
          NormalTextSetting(title: "Archive All Chats", color: Colors.blue),
          Container(
            color: Colors.white,
            child: Divider(
              thickness: 1,
              height: 1,
            ),
          ),
          NormalTextSetting(title: "Clear All Chats"),
          Container(
            color: Colors.white,
            child: Divider(
              thickness: 1,
              height: 1,
            ),
          ),
          NormalTextSetting(title: "Delete All Chats"),
        ],
      ),
    );
  }
}
