import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/webRtc/web_rtc.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';

class ReceiveCall extends StatefulWidget {
  Map? offer_data;
  bool audioCall;
  static const routeName = 'receiveCall';
  ReceiveCall({super.key, this.offer_data, required this.audioCall});

  @override
  State<ReceiveCall> createState() => _ReceiveCallState();
}

class _ReceiveCallState extends State<ReceiveCall> {
  final socketController = Get.put(SocketController());
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final receiverIdController = TextEditingController();
  late RTCPeerConnection _peerConnection;
  late WebRtc webrtc;
  late SimpleWebSocket ws_;
  var callerInfo = {};
  bool micEnabled = true;
  bool callAccepted = false;

  bool ringing = false;
  bool loadedWebRtc = false;
  bool audioCall = false;
  bool isRemoteVideoEnabled = false;
  bool speakerEnabled = false;

  Future<void> initWebRtc() async {
    Map? data = widget.offer_data;
    SimpleWebSocket ws_ = socketController.ws_.value;
    webrtc = WebRtc(ws_, data!["mobile"].toString());
    webrtc.init();

    _peerConnection = await webrtc.createConnection();

    _peerConnection.onAddStream = (stream) {
      webrtc.remoteVideoRenderer.srcObject = stream;
      setState(() {});
      print("Remote Stream Set");
    };

    _peerConnection.onRemoveStream = (stream) {
      webrtc.remoteVideoRenderer.srcObject = null;
      setState(() {});
    };

    _peerConnection.onIceConnectionState = (_) {
      print(
          "ice state changed " + _peerConnection.iceConnectionState.toString());
    };

    setState((() => {loadedWebRtc = true}));

    // var eventData = json.encode({"type": "offer", "receivers": [recv_id]});
    // ws_.send(eventData);
  }

  @override
  void initState() {
    BasicAppUtils().incommingCallRing();
    var caller = chatsController.chats.firstWhere((chat) =>
        chat['conv_mobile'].toString() == widget.offer_data!['caller_mobile']);
    setState(() {
      audioCall = widget.offer_data!['audioCall'];
      callerInfo = {
        'id': caller['id'],
        'name': caller['conv_name'],
        'mobile': caller['conv_mobile'],
        'avatar': caller['avatar']
      };
    });
    initWebRtc();
    initCallWs();
    super.initState();
  }

  void initCallWs() async {
    SimpleWebSocket signallingWs = socketController.ws_.value;
    signallingWs.eventHandlers["rtc.hangup"] = (data) async {
      webrtc.localVideoRenderer.srcObject = null;
      webrtc.remoteVideoRenderer.srcObject = null;

      _peerConnection.close();
      // _peerConnection.dispose();
      await webrtc.destroy();
      userController.currentCall.value = '';
      Navigator.of(context).pop();
    };
  }

  void accept() async {
    await BasicAppUtils().stopIncommingCallRing();
    SimpleWebSocket signallingWs = socketController.ws_.value;

    if (audioCall) {
      webrtc.turnOffVideoCall();
    } else {
      isRemoteVideoEnabled = true;
      setState(() {});
    }
    if (speakerEnabled) {
      webrtc.turnSpeakerOn();
    } else {
      webrtc.turnSpeakerOff();
    }

    // Initialising Listeners
    signallingWs.eventHandlers["rtc.candidate"] = (data) async {
      dynamic session = data;
      dynamic candidate = RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
      await _peerConnection.addCandidate(candidate);
    };

    signallingWs.eventHandlers["rtc.hangup"] = (data) async {
      webrtc.localVideoRenderer.srcObject = null;
      webrtc.remoteVideoRenderer.srcObject = null;

      _peerConnection.close();
      // _peerConnection.dispose();
      await webrtc.destroy();
      userController.currentCall.value = '';
      Navigator.of(context).pop();
    };

    signallingWs.eventHandlers["rtc.remote"] = (data) async {
      setState(() {
        isRemoteVideoEnabled = data['isVideoEnabled'];
      });
    };

    Map? data = widget.offer_data;

    // Setting Remote Description
    dynamic session = data!["sdp"];
    String sdp = write(session, null);
    RTCSessionDescription description = RTCSessionDescription(sdp, 'offer');
    await _peerConnection.setRemoteDescription(description);

    Map<String, dynamic> answerSession =
        await webrtc.createAnswer(_peerConnection);

    // Sending Answer
    var data_ = {
      "type": "rtc.answer",
      "receivers": [data['mobile']],
      "sdp": answerSession,
    };

    webrtc.sendData(data_);

    setState(() {
      callAccepted = true;
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();

    @override
    deactivate() {
      super.deactivate();
    }
  }

  void reject() async {
    await BasicAppUtils().stopIncommingCallRing();
    Map? data = widget.offer_data;
    print("sending reject");
    var data_ = {
      "type": "rtc.reject",
      "receivers": [data!['mobile']],
    };
    userController.currentCall.value = '';
    webrtc.sendData(data_);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          if (callAccepted == false) ...{
            Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  CircleAvatar(
                      minRadius: 80,
                      maxRadius: 80,
                      backgroundImage: NetworkImage(
                          '${dotenv.env['SERVER_MEDIA_URI']}${callerInfo['avatar']}')),
                  const SizedBox(height: 8),
                  Text(callerInfo['name'],
                      style: const TextStyle(
                          fontSize: 24, color: AppColors.titleColor)),
                  const SizedBox(height: 6),
                  Text(
                    audioCall
                        ? 'Audio Call Incoming...'
                        : 'Video Call Incoming...',
                    style: const TextStyle(
                        fontSize: 18, color: AppColors.titleColorLight),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () => {reject()},
                        child: Icon(Icons.call_end)),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: accept,
                        child: Icon(Icons.call)),
                  ],
                ))
          } else ...{
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isRemoteVideoEnabled) ...{
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 1.1,
                        width: MediaQuery.of(context).size.width,
                        child: loadedWebRtc
                            ? RTCVideoView(webrtc.remoteVideoRenderer)
                            : const Text("loading...")),
                  } else ...{
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          CircleAvatar(
                              minRadius: 80,
                              maxRadius: 80,
                              backgroundImage: NetworkImage(
                                  '${dotenv.env['SERVER_MEDIA_URI']}${callerInfo['avatar']}')),
                          const SizedBox(height: 8),
                          Text(callerInfo['name'],
                              style: const TextStyle(
                                  fontSize: 24, color: AppColors.titleColor)),
                          // const SizedBox(height: 6),
                          // const Text(
                          //   '00:00',
                          //   style: TextStyle(
                          //       fontSize: 18, color: AppColors.titleColorLight),
                          // ),
                        ],
                      ),
                    ),
                  },
                  if (!audioCall)
                    Positioned(
                      top: 40,
                      right: 0,
                      child: IconButton(
                          onPressed: webrtc.switchCameraToFace,
                          icon: const Icon(
                            Icons.switch_camera,
                            color: Colors.grey,
                          )),
                    ),
                  if (!audioCall) ...{
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
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 147, 231),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
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
                        print("Tooglng");
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
                        userController.currentCall.value = '';
                        webrtc.hangUp(() {
                          Navigator.of(context).pop();
                          _peerConnection.close();
                          // _peerConnection.dispose();
                        });
                      },
                      icon: const Icon(
                        Icons.call_end,
                        size: 30,
                        color: Colors.red,
                      )),
                ],
              ),
            )
          }
        ]));
  }
}
