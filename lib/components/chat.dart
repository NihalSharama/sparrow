import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatCardComponent extends StatefulWidget {
  final String avatar;
  final String name;
  final String lastMsg;
  final String lastMsgDate;
  final String msgStatus; // msgStatus: sent, received, seen

  const ChatCardComponent(
      {super.key,
      required this.avatar,
      required this.name,
      required this.lastMsg,
      required this.lastMsgDate,
      required this.msgStatus});

  @override
  State<ChatCardComponent> createState() => _ChatCardComponentState();
}

class _ChatCardComponentState extends State<ChatCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        child: Container(
            height: 85,
            width: double.infinity,
            // ignore: sort_child_properties_last
            child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      minRadius: 30,
                      maxRadius: 30,
                      backgroundImage: (widget.avatar != ''
                          ? AssetImage(widget.avatar)
                          : const AssetImage('assets/images/chat_avatar.png')),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 61, 61, 61)),
                          ),
                          Row(
                            children: [
                              if (widget.msgStatus == 'sent') ...{
                                const Icon(
                                  Icons.done,
                                  color: Colors.grey,
                                )
                              } else if (widget.msgStatus == 'received') ...{
                                const Icon(Icons.done_all, color: Colors.grey)
                              } else ...{
                                const Icon(
                                  Icons.done_all,
                                  color: Colors.blue,
                                )
                              },
                              const SizedBox(width: 10),
                              if (widget.lastMsg.length >= 29) ...{
                                Text(
                                  '${widget.lastMsg.substring(0, 30)}...',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                )
                              } else ...{
                                Text(
                                  widget.lastMsg,
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
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 211, 211, 211))))));
  }
}
