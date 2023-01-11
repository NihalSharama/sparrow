import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' as getx;
import 'package:sdp_transform/sdp_transform.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/pages/calls/control_panel.dart';
import 'package:sparrow/pages/chatRoom.dart';

class CallingPage extends StatefulWidget {
  static const routeName = 'calls/';
  final bool isVideoCall;

  const CallingPage({
    Key? key,
    required this.isVideoCall,
  }) : super(key: key);

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final sdpController = TextEditingController();
  final chatsController = getx.Get.put(ChatsController());
  var isMute = false;
  var isVideo = false;

  onPressMute() {
    setState(() {
      isMute = !isMute;
    });
  }

  onPressVideo() {
    setState(() {
      isVideo = !isVideo;
    });
  }

  @override
  void initState() {
    chatsController.remoteVideoRenderer.initialize();
    chatsController.localVideoRenderer.initialize();
    chatsController.addUserMedia();
    chatsController.offer.value = true;
    //  chatsController.createOffer();
    // Future.delayed(Duration.zero, () async {
    // });
    super.initState();
  }

  @override
  void dispose() async {
    await chatsController.localVideoRenderer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatsController.streamController,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('snapshot: ${snapshot.data}');

        if (snapshot.data != null) {
          var payload = json.decode(snapshot.data);
          if (payload['event_type'] == 'sdp.receive') {
            if (chatsController.offer.value) {
              print('setting candidate');
              chatsController.setRemoteDescription(payload['sdp']);
              chatsController.addCandidate(payload['candidate']);
            } else if (!chatsController.offer.value) {
              print('creating answer');
              chatsController.setRemoteDescription(payload['sdp']);
              chatsController.createAnswer(payload['caller_mobile']);
            }
          } else if (payload['status'] != null) {
            if (payload['status'] == 'offline') {
              chatsController.createOffer();
              chatsController.callingStatus.value = 'connecting';
            } else {
              // chatsController.createOffer(); 
              chatsController.callingStatus.value = 'ringing';
            }
          }
        }

        print('isoffer: ${widget.isVideoCall}');

        return SafeArea(
            child: Scaffold(
          body: Stack(
            children: [
              if ((widget.isVideoCall || isVideo)) ...{
                Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: RTCVideoView(
                    chatsController.remoteVideoRenderer,
                    mirror: true,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 180,
                    width: 100,
                    margin: const EdgeInsets.only(right: 30, bottom: 100),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 63, 63, 63)),
                    child: RTCVideoView(
                      chatsController.localVideoRenderer,
                      mirror: true,
                    ),
                  ),
                ),
              } else ...{
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        const CircleAvatar(
                            maxRadius: 60,
                            minRadius: 60,
                            backgroundImage:
                                AssetImage('assets/images/chat_avatar.png')),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              chatsController
                                  .chatRoomDetails.value["conv_name"],
                              style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.titleColorLight)),
                        ),
                        const Text('00:46',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.titleColorLight))
                      ],
                    ),
                  ),
                )
              },
              Align(
                alignment: Alignment.bottomCenter,
                child: ControlPanel(
                    isMute: isMute,
                    isVideo: isVideo,
                    onPressMute: onPressMute,
                    onPressVideo: onPressVideo,
                    onHangUp: () {
                      chatsController.createOffer();
                    }),
              )
            ],
          ),
        ));
      },
    );
  }
}
