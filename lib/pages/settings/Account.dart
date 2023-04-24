import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/settingWidget.dart';
import 'package:flutter/material.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/settings/sensitive_settings.dart';
import 'package:sparrow/pages/settings/settingPage.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, LandingScreen.routeName + SettingPage.routeName);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: const Text(
          "Account",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          // SettingWidget2(title: "Privacy"),
          // SettingWidget2(title: "Security"),
          // SettingWidget2(title: "Two-Step Verification"),
          SettingWidget2(
              title: "Change Number",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SensitiveSettings(isChangeNumber: true)));
              }),
          // SizedBox(height: 30),
          // SettingWidget2(title: "Request Account Info"),
          SettingWidget2(
            title: "Delete My Account",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SensitiveSettings(isChangeNumber: false)));
            },
          ),
        ],
      ),
    );
  }
}
