import 'package:sparrow/components/settingWidget.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          "Notification",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "MESSAGE NOTIFICATON",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          SettingWidgetWithButton(title: "Show Notifications"),
          Container(
            color: Colors.white,
            child: Divider(
              thickness: 1,
              height: 1,
            ),
          ),
          SettingWidget2(
            title: "Sound",
            note: "Note",
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "GROUP   NOTIFICATON",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          SettingWidgetWithButton(title: "Show Notifications"),
          Container(
            color: Colors.white,
            child: Divider(
              thickness: 1,
              height: 1,
            ),
          ),
          SettingWidget2(
            title: "Sound",
            note: "Note",
          ),
          const SizedBox(
            height: 30,
          ),
          SettingWidget2(
            title: "In-App Notifications",
            subtitle: "Banners, Sounds, Vibrate",
          ),
          const SizedBox(
            height: 30,
          ),
          SettingWidgetWithButton(title: "Show Preview"),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Preview message text inside new message notifications.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          NormalTextSetting(title: "Reset Notification Settings")
        ],
      ),
    );
  }
}
