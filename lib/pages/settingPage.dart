import 'package:flutter/material.dart';

import '../common/global_variables.dart';

class SettingPage extends StatelessWidget {
  static const routeName = 'setting';

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: AppColors.backgroundGrayDark,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundGrayDark,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          height: 80,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sabohiddin"),
                  Text("Digital goodies designer - Pixsellz")
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
