import 'package:flutter/material.dart';

import '../common/global_variables.dart';

class StarredMessage extends StatelessWidget {
  const StarredMessage({super.key});

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
          "Starred Messages",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage("assets/images/Oval.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "No Starred Messages",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Tap and hold on any message to star it, so you can easily find it later.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
