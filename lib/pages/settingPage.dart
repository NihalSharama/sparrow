import 'package:flutter/material.dart';
import 'package:sparrow/components/setting_widget.dart';

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
        backgroundColor: AppColors.settingPageColor,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.settingPageColor,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
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
          const SizedBox(
            height: 40,
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.black12))),
              height: 115,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/starred.svg",
                      title: "Starred Messages",
                      num: "",
                      text: ""),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      // height: 1,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/desktop.svg",
                      title: "WhatsApp Web/Desktop",
                      num: "",
                      text: ""),
                ],
              )),
          const SizedBox(
            height: 40,
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.black12))),
              height: 250,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/account.svg",
                      title: "Accounts",
                      num: "",
                      text: ""),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      // height: 1,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/chatsSetting.svg",
                      title: "Chats",
                      num: "",
                      text: ""),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      // height: 1,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/notification.svg",
                      title: "Notifications",
                      num: "",
                      text: ""),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      // height: 1,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/usages.svg",
                      title: "Data and Storage Usage",
                      num: "",
                      text: ""),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.black12))),
              height: 115,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/help.svg",
                      title: "Help",
                      num: "",
                      text: ""),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      // height: 1,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SettingWidget(
                      svg: "assets/icons/tellFriend.svg",
                      title: "Tell a Friend",
                      num: "",
                      text: ""),
                ],
              ))
        ]),
      ),
    );
  }
}
