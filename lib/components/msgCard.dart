import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MsgCardComponent extends StatelessWidget {
  final String text;
  final String time;
  final String msgStatus;
  final String from;
  // ignore: prefer_typing_uninitialized_variables
  const MsgCardComponent(
      {super.key,
      required this.text,
      required this.time,
      required this.msgStatus,
      required this.from});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (from == 'you'
          ? const Color.fromRGBO(220, 247, 197, 1)
          : const Color.fromARGB(255, 234, 234, 234)),
      shape: RoundedRectangleBorder(
          borderRadius: (from == 'you'
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
      elevation: 2,
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
              time,
              style: const TextStyle(
                  color: (Color.fromARGB(255, 43, 43, 43)), fontSize: 10),
            ),
            if (from == 'you') ...{
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
