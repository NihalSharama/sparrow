import 'package:flutter/material.dart';
import 'package:sparrow/components/setting_widget.dart';
import 'package:sparrow/pages/Account.dart';
import 'package:sparrow/pages/Notification.dart';
import 'package:sparrow/pages/chat_setting.dart';
import 'package:sparrow/pages/edit_profile.dart';
import 'package:sparrow/pages/starredMessage.dart';
import 'package:sparrow/pages/usage.dart';

import '../common/global_variables.dart';

class SettingPage extends StatelessWidget {
  static const routeName = 'setting';
  final subroute;

  SettingPage({super.key, this.subroute = 'settings'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Setting",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        backgroundColor: AppColors.settingPageColor,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
            child: Container(
              width: double.infinity,
              height: 90,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          AssetImage("assets/images/chat_avatar.png"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Sabohiddin",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Digital goodies designer - Pixsellz",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),

          SettingWidget(
            svg: "assets/icons/starred.svg",
            title: "Starred Messages",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StarredMessage()));
            },
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Divider(
          //     // height: 1,
          //     thickness: 2,
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // SettingWidget(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => EditProfile()));
          //     },
          //     svg: "assets/icons/desktop.svg",
          //     title: "WhatsApp Web/Desktop",
          //     num: "",
          //     text: ""),

          const SizedBox(
            height: 40,
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountPage()));
            },
            svg: "assets/icons/account.svg",
            title: "Accounts",
          ),

          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                // height: 1,
                thickness: 2,
              ),
            ),
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatSetting()));
            },
            svg: "assets/icons/chatsSetting.svg",
            title: "Chats",
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                // height: 1,
                thickness: 2,
              ),
            ),
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
            svg: "assets/icons/notification.svg",
            title: "Notifications",
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                // height: 1,
                thickness: 2,
              ),
            ),
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Usage()));
            },
            svg: "assets/icons/usages.svg",
            title: "Data and Storage Usage",
          ),

          const SizedBox(
            height: 20,
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
            svg: "assets/icons/help.svg",
            title: "Help",
          ),

          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                // height: 1,
                thickness: 2,
              ),
            ),
          ),

          SettingWidget(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
            svg: "assets/icons/tellFriend.svg",
            title: "Tell a Friend",
          ),
        ]),
      ),
    );
  }
}
