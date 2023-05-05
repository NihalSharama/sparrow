import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CallWidget extends StatelessWidget {
  final String avatar;
  final String call;
  final String name;
  final String callStatus;
  const CallWidget(
      {Key? key,
      required this.avatar,
      required this.call,
      required this.callStatus,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (callStatus == "missed") ...{
                        Text(
                          name,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      } else ...{
                        Text(
                          name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      },
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/filled_call.svg"),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(call, style: TextStyle(fontSize: 14))
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    DateFormat('h:mma  ').format(DateTime.now()),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      )),
    );
  }
}
