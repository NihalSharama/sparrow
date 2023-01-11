import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/controllers/chatsController.dart';

class RecieveCall extends StatefulWidget {
  final String sdp;
  const RecieveCall({super.key, required this.sdp});

  @override
  State<RecieveCall> createState() => _RecieveCallState();
}

class _RecieveCallState extends State<RecieveCall> {
  final chatsController = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Call Utha BSDK'),
          CustomButton(
              onPressed: () {
                chatsController.setRemoteDescription(widget.sdp);
                chatsController.createAnswer('1111111111');
              },
              text: 'ANSWER')
        ],
      ),
    );
  }
}
