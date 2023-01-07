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
  final isVideoCall;
  const CallingPage({
    Key? key,
    this.isVideoCall,
  }) : super(key: key);

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  final sdpController = TextEditingController();
  final chatsController = getx.Get.put(ChatsController());
  var isMute = false;
  var isVideo = true;

  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  initRenderer() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      _remoteVideoRenderer.srcObject = stream;
      print('stream: ' + stream.id);
    };

    return pc;
  }

  void _createOffer() async {
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    print(json.encode(session));
    _offer = true;

    _peerConnection!.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());
    print(json.encode(session));

    _peerConnection!.setLocalDescription(description);
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');
    print(description.toMap());

    await _peerConnection!.setRemoteDescription(description);
  }

  void _addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);
    print('session : $jsonString');
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection!.addCandidate(candidate);
  }

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
    initRenderer();
    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
    });
    super.initState();
  }

  @override
  void dispose() async {
    await _localVideoRenderer.dispose();
    // await _remoteVideoRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(children: [
          Flexible(
            child: Container(
              key: const Key('local'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localVideoRenderer),
            ),
          ),
          Flexible(
            child: Container(
              key: const Key('remote'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(
                _remoteVideoRenderer,
                mirror: true,
              ),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          if (true) ...{
            Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(
                _localVideoRenderer,
                mirror: true,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 180,
                width: 100,
                margin: const EdgeInsets.only(right: 30, bottom: 100),
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 63, 63, 63)),
                child: RTCVideoView(
                  _localVideoRenderer,
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
                          chatsController.chatRoomDetails.value["conv_name"],
                          style: TextStyle(
                              fontSize: 24, color: AppColors.titleColorLight)),
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
                onHangUp: () {}),
          )
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.5,
          //         child: TextField(
          //           controller: sdpController,
          //           keyboardType: TextInputType.multiline,
          //           maxLines: 4,
          //           maxLength: TextField.noMaxLength,
          //         ),
          //       ),
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         ElevatedButton(
          //           onPressed: _createOffer,
          //           child: const Text("Offer"),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         ElevatedButton(
          //           onPressed: _createAnswer,
          //           child: const Text("Answer"),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         ElevatedButton(
          //           onPressed: _setRemoteDescription,
          //           child: const Text("Set Remote Description"),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         ElevatedButton(
          //           onPressed: _addCandidate,
          //           child: const Text("Set Candidate"),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ],
      ),
    ));
  }
}
