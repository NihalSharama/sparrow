import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/services/call-service.dart';

class CallWidget extends StatelessWidget {
  final String id;
  final String avatar;
  final DateTime time;
  final String name;
  final String callStatus;
  const CallWidget(
      {Key? key,
      required this.avatar,
      required this.time,
      required this.callStatus,
      required this.name,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callsController = Get.put(CallsController());
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
                    backgroundImage: NetworkImage(
                        '${dotenv.env['SERVER_MEDIA_URI']}$avatar'),
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
                            Text(callStatus, style: TextStyle(fontSize: 14))
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd/MM/yy').format(time),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        DateFormat('h:mma').format(time),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        CallServices().removeCallLog(id);

                        callsController.calls
                            .removeWhere((log) => log['id'].toString() == id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.appBarColor,
                      ))
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
