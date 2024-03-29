import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparrow/components/settingWidget.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/settings/Account.dart';
import 'package:sparrow/pages/settings/allStarred_messages.dart';
import 'package:sparrow/pages/settings/edit_profile.dart';

import '../../common/global_variables.dart';
import 'chat_setting.dart';

class SettingPage extends StatelessWidget {
  static const routeName = 'setting';

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    return Obx(
      () => Scaffold(
        backgroundColor: Color.fromARGB(236, 239, 239, 244),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            '${dotenv.env['SERVER_MEDIA_URI']}${userController.user['profile_pic']}'), // '${dotenv.env['SERVER_MEDIA_URI']}${userController.user['profile_pic']}' use this for new users
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userController.user['first_name'] +
                                ' ' +
                                userController.user['last_name'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Mobile: ${userController.user['mobile']}',
                            style: const TextStyle(
                                color: AppColors.descriptionColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            userController.user['bio'] == ''
                                ? "Bio: Busy"
                                // ignore: prefer_interpolation_to_compose_strings
                                : 'Bio: ' + userController.user['bio'],
                            style: const TextStyle(
                                color: AppColors.descriptionColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllStarredMessages()));
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SettingWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()));
              },
              svg: "assets/icons/account.svg",
              title: "Accounts",
            ),
            Container(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            SettingWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatSetting()));
              },
              svg: "assets/icons/chatsSetting.svg",
              title: "Chats",
            ),
            Container(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  // height: 1,
                  thickness: 2,
                ),
              ),
            ),
            // SettingWidget(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const NotificationPage()));
            //   },
            //   svg: "assets/icons/notification.svg",
            //   title: "Notifications",
            // ),
            // Container(
            //   color: Colors.white,
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 10),
            //     child: Divider(
            //       // height: 1,
            //       thickness: 2,
            //     ),
            //   ),
            // ),
            // SettingWidget(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => const Usage()));
            //   },
            //   svg: "assets/icons/usages.svg",
            //   title: "Data and Storage Usage",
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            SettingWidget(
              onTap: () {},
              svg: "assets/icons/help.svg",
              title: "Help",
            ),
            Container(
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  // height: 1,
                  thickness: 2,
                ),
              ),
            ),
            // SettingWidget(
            //   onTap: () async {
            //     if (dotenv.env['APP_PLAYSTORE_URL'] != null) {
            //       await Share.share(dotenv.env['APP_PLAYSTORE_URL']!);
            //     }
            //   },
            //   svg: "assets/icons/tellFriend.svg",
            //   title: "Tell a Friend",
            // ),
          ]),
        ),
      ),
    );
  }
}
