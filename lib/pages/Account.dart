import 'package:flutter/material.dart';

import '../components/setting_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
          SettingWidget2(title: "Privacy"),
          SettingWidget2(title: "Security"),
          SettingWidget2(title: "Two-Step Verification"),
          SettingWidget2(title: "Change Number"),
          const SizedBox(
            height: 30,
          ),
          SettingWidget2(title: "Request Account Info"),
          SettingWidget2(title: "Delete My Account"),
        ],
      ),
    );
  }
}
