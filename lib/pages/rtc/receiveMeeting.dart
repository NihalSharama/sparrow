import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/pages/rtc/meetingScreen.dart';

class ReceiveMeetingScreen extends StatefulWidget {
  final Map meetingDetails;
  const ReceiveMeetingScreen({super.key, required this.meetingDetails});
  static const routeName = 'receive-meeting';

  @override
  State<ReceiveMeetingScreen> createState() => _ReceiveMeetingScreenState();
}

class _ReceiveMeetingScreenState extends State<ReceiveMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(40),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          minRadius: 80,
                          maxRadius: 80,
                          backgroundImage: NetworkImage(
                              '${dotenv.env['SERVER_MEDIA_URI']}${widget.meetingDetails['avatar']}')),
                      const SizedBox(height: 8),
                      Text(widget.meetingDetails['name'],
                          style: const TextStyle(
                              fontSize: 24, color: AppColors.titleColor)),
                      const SizedBox(height: 6),
                      const Text(
                        'Group Meeting Ongoing...',
                        style: TextStyle(
                            fontSize: 18, color: AppColors.titleColorLight),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.call_end)),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupMeetingScreen(
                                          channelName:
                                              widget.meetingDetails['id'],
                                          isCalling: false,
                                        )));
                          },
                          child: const Icon(Icons.call)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
