import 'dart:async';

import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/services/call-service.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/utils/webRtc/web_rtc.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CallScreen extends StatefulWidget {
  String? recvMobile;
  bool audioCall;
  CallScreen({super.key, this.recvMobile, required this.audioCall});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isRinging = false;
  final socketController = Get.put(SocketController());
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final receiverIdController = TextEditingController();
  late RTCPeerConnection _peerConnection;
  late WebRtc webrtc;
  bool loadedWebRtc = false;
  bool ringing = false;
  int numberOfRang = 0;
  bool remoteSet = false;
  bool isHangedUp = false;
  bool micEnabled = true;
  bool speakerEnabled = false;
  bool audioCall = false;
  bool isRemoteVideoEnabled = false;

  late Timer _ringingTimer;

  void initCallWs(SimpleWebSocket ws) {
    // Adding Event Handlers
    // Incoming Offer Rejection
    ws.eventHandlers["rtc.reject"] = (data) async {
      // Rejecting Connection
      // await _peerConnection.removeStream()
      webrtc.localVideoRenderer.srcObject = null;
      webrtc.remoteVideoRenderer.srcObject = null;
      await webrtc.destroy();
      _peerConnection.close();
      Navigator.of(context).pop();
    };

    ws.eventHandlers["rtc.hangup"] = (data) async {
      // Rejecting Connection
      webrtc.localVideoRenderer.srcObject = null;
      webrtc.remoteVideoRenderer.srcObject = null;

      // setState(() {
      //   isHangedUp = true;
      // });
      _ringingTimer.cancel();

      await webrtc.destroy();
      _peerConnection.close();
      await _peerConnection.close();
      Navigator.of(context).pop();
    };

    // Incoming Answer
    ws.eventHandlers["rtc.answer"] = (data) async {
      dynamic session = data["sdp"];
      String sdp = write(session, null);

      RTCSessionDescription description = RTCSessionDescription(sdp, 'answer');
      await _peerConnection.setRemoteDescription(description);

      setState(() {
        remoteSet = true;
      });
    };

    // Incoming Candidate
    ws.eventHandlers["rtc.candidate"] = (data) async {
      dynamic session = data;
      dynamic candidate = RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
      await _peerConnection.addCandidate(candidate);
    };

    ws.eventHandlers["rtc.remote"] = (data) async {
      print('turned of camera');
      setState(() {
        isRemoteVideoEnabled = data['isVideoEnabled'];
      });
    };
  }

  Future<void> makeCall(String? recvMobile) async {
    SimpleWebSocket signallingWs = socketController.ws_.value;
    webrtc = WebRtc(signallingWs, recvMobile!);

    // Adding Event Listeners to Signalling WS
    initCallWs(signallingWs);
    // Inititalising WebRTC Connection (Main Work)
    webrtc.init();

    _peerConnection = await webrtc.createConnection();
    if (widget.audioCall) {
      webrtc.turnOffVideoCall();
    } else {
      webrtc.turnOnVideoCall();
      isRemoteVideoEnabled = true;
      setState(() {});
    }
    if (speakerEnabled) {
      webrtc.turnSpeakerOn();
    } else {
      webrtc.turnSpeakerOff();
    }
    _peerConnection.onAddStream = (stream) {
      webrtc.remoteVideoRenderer.srcObject = stream;
      setState(() {});
    };

    _peerConnection.onRemoveStream = (stream) {
      webrtc.remoteVideoRenderer.srcObject = null;
      setState(() {});
    };

    // Creates and Sends
    Map<String, dynamic> offerData = await webrtc.createOffer(
        _peerConnection,
        audioCall,
        chatsController.chatRoomDetails.value['receiver_info']['mobile']
            .toString());

    _ringingTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (remoteSet || isHangedUp) {
        print(
            {'remote': remoteSet.toString(), 'hanged': isHangedUp.toString()});
        timer.cancel();
      } else if (numberOfRang <= 8) {
        webrtc.sendData(offerData);
        numberOfRang += 2;
      } else {
        webrtc.hangUp(() {
          Navigator.pop(context);
          _peerConnection.close();
        });
        timer.cancel();
      }
    });

    try {
      FirebaseServices().sendPushNotification(
          recvMobile,
          'notification.call',
          'Sparrow',
          'Incomming ${audioCall ? 'Audio' : 'Video'} Call...',
          {'audioCall': audioCall});
    } catch (_) {}

    // Refreshes Page
    setState(() {
      loadedWebRtc = true;
    });

    // creating call Log
    await CallServices()
        .createCallLog(chatsController.chatRoomDetails['id'].toString(), true);
  }

  @override
  void initState() {
    makeCall(widget.recvMobile);
    setState(() {
      audioCall = widget.audioCall;
    });
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();

    @override
    deactivate() {
      super.deactivate();

      webrtc.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo: remote video widget when remote video is null

    return Scaffold(
      body: SafeArea(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            flex: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isRemoteVideoEnabled) ...{
                  Container(
                      child: loadedWebRtc
                          ? RTCVideoView(webrtc.remoteVideoRenderer)
                          : const Center(child: Text("loading..."))),
                } else ...{
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        CircleAvatar(
                            minRadius: 80,
                            maxRadius: 80,
                            backgroundImage: NetworkImage(
                                '${dotenv.env['SERVER_MEDIA_URI']}${chatsController.chatRoomDetails['avatar']}')),
                        const SizedBox(height: 8),
                        Text(chatsController.chatRoomDetails['conv_name'],
                            style: const TextStyle(
                                fontSize: 24, color: AppColors.titleColor)),
                        const SizedBox(height: 6),
                        Text(
                          remoteSet ? '' : 'Calling...',
                          style: const TextStyle(
                              fontSize: 18, color: AppColors.titleColorLight),
                        )
                      ],
                    ),
                  ),
                },
                if (!audioCall)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: webrtc.switchCameraToFace,
                        icon: const Icon(
                          Icons.switch_camera,
                          color: Colors.grey,
                        )),
                  ),
                if (!audioCall & remoteSet) ...{
                  Positioned(
                    bottom: 5,
                    right: 0,
                    height: 100,
                    width: 100,
                    child: Container(
                        child: loadedWebRtc
                            ? RTCVideoView(webrtc.localVideoRenderer)
                            : Container(
                                color: Colors.black,
                              )),
                  )
                }
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 147, 231),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        if (speakerEnabled) {
                          setState(() {
                            speakerEnabled = false;
                            webrtc.turnSpeakerOff();
                          });
                        } else {
                          setState(() {
                            speakerEnabled = true;
                            webrtc.turnSpeakerOn();
                          });
                        }
                      },
                      icon: Icon(
                        speakerEnabled
                            ? Icons.volume_up
                            : Icons.volume_off_sharp,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        if (audioCall) {
                          setState(() {
                            audioCall = false;
                            webrtc.turnOnVideoCall();
                          });
                        } else {
                          setState(() {
                            audioCall = true;
                            webrtc.turnOffVideoCall();
                          });
                        }
                      },
                      icon: Icon(
                        audioCall ? Icons.videocam_off : Icons.videocam,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        if (micEnabled) {
                          webrtc.toogleMic(false);
                          setState(() => {micEnabled = false});
                        } else {
                          webrtc.toogleMic(true);
                          setState(() => {micEnabled = true});
                        }
                      },
                      icon: Icon(
                        micEnabled ? Icons.mic_rounded : Icons.mic_off,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isHangedUp = true;
                        });
                        webrtc.hangUp(() {
                          Navigator.pop(context);
                          _peerConnection.close();
                        });
                      },
                      icon: const Icon(
                        Icons.call_end,
                        size: 30,
                        color: Colors.red,
                      )),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
