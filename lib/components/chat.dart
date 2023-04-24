import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';

class ChatCardComponent extends StatefulWidget {
  final String avatar;
  final String name;
  final String? lastMsg;
  final String? lastMsgDate;
  final String? lastMsgSender;
  final String? msgStatus; // msgStatus: sent, received, seen

  const ChatCardComponent({
    super.key,
    required this.avatar,
    required this.name,
    required this.lastMsg,
    required this.lastMsgDate,
    required this.msgStatus,
    this.lastMsgSender,
  });

  @override
  State<ChatCardComponent> createState() => _ChatCardComponentState();
}

class _ChatCardComponentState extends State<ChatCardComponent> {
  final userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    String? lastMsg = BasicAppUtils().utf8convert(widget.lastMsg!);
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
        child: Container(
          height: 85,
          width: double.infinity,
          // ignore: sort_child_properties_last
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    minRadius: 30,
                    maxRadius: 30,
                    backgroundImage: (NetworkImage(widget.avatar)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 61, 61, 61)),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            if (widget.lastMsg == null) ...{
                              const Text(
                                'No Message Yet!',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 87, 87, 87)),
                              )
                            } else ...{
                              if (userController.user['id'].toString() ==
                                  widget.lastMsgSender)
                                const Text('You: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 87, 87, 87))),
                              if (widget.lastMsg!.length >= 25)
                                Text(
                                  '${lastMsg.substring(0, 25)}...',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                )
                              else
                                Text(
                                  lastMsg,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                )
                            }
                          ],
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right)
                ],
              )),
        ));
  }
}
