import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/settings/settingPage.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ExitEditingProfilePopup extends StatefulWidget {
  final GlobalKey<FormState> editNameFormKey;
  final GlobalKey<FormState> editEmailFormKey;
  final GlobalKey<FormState> editBioFormKey;
  const ExitEditingProfilePopup(
      {super.key,
      required this.editNameFormKey,
      required this.editEmailFormKey,
      required this.editBioFormKey});

  @override
  State<ExitEditingProfilePopup> createState() =>
      _ExitEditingProfilePopupState();
}

class _ExitEditingProfilePopupState extends State<ExitEditingProfilePopup> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, LandingScreen.routeName + SettingPage.routeName);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: prefer_const_constructors
                  Text(
                    "Discard & Exit",
                    style: const TextStyle(
                        color: AppColors.titleColorLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.cancel,
                    color: Colors.red.shade300,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundGrayLight,
            thickness: 1.2,
          ),
          if (userController.bioController.text.isNotEmpty ||
              userController.emailController.text.isNotEmpty ||
              userController.usernameController.text.isNotEmpty) ...{
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: () async {
                  await userController.updateUserProfile(widget.editNameFormKey,
                      widget.editEmailFormKey, widget.editBioFormKey);

                  Navigator.pushNamed(
                      context, LandingScreen.routeName + SettingPage.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Save & Exit",
                      style: TextStyle(
                          color: AppColors.titleColorLight,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.save,
                      color: Colors.cyan.shade300,
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color: AppColors.backgroundGrayLight,
              thickness: 1.2,
            ),
          },
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Keep Editing",
                    style: TextStyle(
                        color: AppColors.titleColorLight,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.edit,
                    color: Colors.green.shade300,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
