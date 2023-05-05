import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/settingWidget.dart';
import 'package:flutter/material.dart';

class Usage extends StatefulWidget {
  const Usage({super.key});

  @override
  State<Usage> createState() => _UsageState();
}

class _UsageState extends State<Usage> {
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
            color: AppColors.appBarColor,
          ),
        ),
        title: const Text(
          "Data and Storage Usage",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(
            height: 20,
          ),
          Text(
            "MEDIA AUTO-DOWNLOAD",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          SettingWidget2(
            title: "Photos",
            note: "Wi-Fi and Cellular",
          ),
          SettingWidget2(
            title: "Audio",
            note: "Wifi",
          ),
          SettingWidget2(
            title: "Videos",
            note: "Wifi",
          ),
          SettingWidget2(
            title: "Documents",
            note: "Wifi",
          ),
          NormalTextSetting(
            title: "Reset Auto-Download Settings",
            color: Colors.black38,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Voice Messages are always automatically downloaded for the best communication experience.",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "CALL SETTING",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 5,
          ),
          SettingWidgetWithButton(title: "Low Data Usage"),
          SizedBox(
            height: 10,
          ),
          Text(
            "Lower the amount of data used during a WhatsAoo call on cellular.",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 30,
          ),
          SettingWidget2(title: "Network Usage"),
          SettingWidget2(title: "Storage Usage"),
        ],
      ),
    );
  }
}
