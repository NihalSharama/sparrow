import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sparrow/controllers/userController.dart';

class MsgCardComponent extends StatelessWidget {
  final String text;
  final DateTime time;
  final String msgStatus;
  final int from;
  final bool isStarred;
  // ignore: prefer_typing_uninitialized_variables
  const MsgCardComponent(
      {super.key,
      required this.text,
      required this.time,
      required this.msgStatus,
      required this.from,
      required this.isStarred});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final timestamp = DateFormat('h:mma').format(time);

    return Card(
      color: (from == userController.userId.value
          ? const Color.fromARGB(255, 231, 255, 211)
          : const Color.fromARGB(255, 255, 255, 255)),
      shape: RoundedRectangleBorder(
          borderRadius: (from == userController.userId.value
              ? const BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))
              : const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)))),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: (Color.fromARGB(255, 43, 43, 43))),
            ),
            const SizedBox(width: 10),
            Text(
              timestamp,
              style: const TextStyle(
                  color: (Color.fromARGB(255, 43, 43, 43)), fontSize: 10),
            ),
            if (from == userController.userId.value) ...{
              const SizedBox(width: 8),
              if (msgStatus == 'sent') ...{
                const Icon(
                  Icons.done,
                  color: Colors.grey,
                  size: 14,
                )
              } else if (msgStatus == 'received') ...{
                const Icon(
                  Icons.done_all,
                  color: Colors.grey,
                  size: 14,
                )
              } else ...{
                const Icon(
                  Icons.done_all,
                  color: Colors.blue,
                  size: 14,
                )
              },
            }
          ],
        ),
      ),
    );
  }
}
