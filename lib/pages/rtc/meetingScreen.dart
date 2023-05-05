import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class GroupMeetingScreen extends StatefulWidget {
  final String channelName;
  final bool isCalling;

  const GroupMeetingScreen(
      {super.key, required this.channelName, required this.isCalling});

  @override
  State<GroupMeetingScreen> createState() => _GroupMeetingScreenState();
}

class _GroupMeetingScreenState extends State<GroupMeetingScreen> {
  final socketController = Get.put(SocketController());
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final receiverIdController = TextEditingController();

  bool micEnabled = true;
  bool videoEnabled = true;
  bool speakerEnabled = false;
  bool loading = false;
  bool isLocalUserJoined = false;

  late RtcEngine _engine;
  List _remoteUids = [];

  int generateRandomUid() {
    var random = Random();
    return random.nextInt(1000000);
  }

  Future<void> initializeAgora() async {
    final int uid = generateRandomUid();
    // final int uid = userController.user['mobile'];

    setState(() {
      loading = true;
    });

    _engine = await RtcEngine.create(dotenv.env['AGORA_APP_ID']!);

    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);

    // event handlers
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      print("Meeting ${widget.isCalling ? 'Started' : 'Joined'}");
      toasterSuccessMsg("Meeting ${widget.isCalling ? 'Started' : 'Joined'}");
    }, userJoined: (uid, elapsed) async {
      var userName = await getUserNameFromMobile(uid.toString());
      print('$userName Joined');

      _remoteUids.add(uid);
      setState(() {});

      toasterSuccessMsg('$userName Joined');
    }, userOffline: (uid, elapsed) async {
      var userName = await getUserNameFromMobile(uid.toString());
      _remoteUids.remove(uid);
      setState(() {});

      print('$userName Left');
      toasterSuccessMsg('$userName Left');
    }));
    _engine.leaveChannel();

    print(uid);
    await _engine.joinChannel(null, widget.channelName, null, uid);
    setState(() {
      isLocalUserJoined = true;
    });
  }

  Future<void> createOrJoinMeeting() async {
    SimpleWebSocket signallingWs = socketController.ws_.value;

    await initializeAgora();
    chatsController.chatRoomDetails['users']
        .remove(userController.user['mobile']);

    if (widget.isCalling) {
      // send data to receivers through signalling server
      var data = {
        "type": "group.meeting",
        "receivers": chatsController.chatRoomDetails['users'],
        "id": chatsController.chatRoomDetails['id'].toString(),
        "name": chatsController.chatRoomDetails['group_name'],
        "avatar": chatsController.chatRoomDetails['group_profile']
      };
      signallingWs.send(json.encode(data));

      try {
        for (var receiverMobile in chatsController.chatRoomDetails['users']) {
          FirebaseServices().sendPushNotification(
              receiverMobile.toString(),
              'notification.call',
              chatsController.chatRoomDetails['group_name'],
              'Ongoing Group Meeting...',
              {'id': chatsController.chatRoomDetails['id']});
        }
      } catch (_) {}
    }
  }

  @override
  void initState() {
    createOrJoinMeeting();

    super.initState();
  }

  @override
  void deactivate() {
    // clear users
    _remoteUids.clear();
    // destroy sdk
    _engine.leaveChannel();

    super.deactivate();

    @override
    deactivate() {
      super.deactivate();
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
                renderRemoteView(context),
                if (videoEnabled) ...{
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          _engine.switchCamera();
                        },
                        icon: const Icon(
                          Icons.switch_camera,
                          color: Colors.grey,
                        )),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      width: 100,
                      height: 130,
                      child: SizedBox(
                          width: 100,
                          height: 130,
                          child: isLocalUserJoined
                              ? RtcLocalView.SurfaceView(
                                  channelId: widget.channelName,
                                )
                              : const Text('Loading...')))
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
                        setState(() {
                          speakerEnabled = !speakerEnabled;
                        });
                        _engine.setEnableSpeakerphone(speakerEnabled);
                      },
                      icon: Icon(
                        speakerEnabled
                            ? Icons.volume_up
                            : Icons.volume_off_sharp,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          videoEnabled = !videoEnabled;
                        });
                        _engine.muteLocalVideoStream(!videoEnabled);
                      },
                      icon: Icon(
                        videoEnabled ? Icons.videocam : Icons.videocam_off,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() => {micEnabled = !micEnabled});
                        _engine.muteLocalAudioStream(!micEnabled);
                      },
                      icon: Icon(
                        micEnabled ? Icons.mic_rounded : Icons.mic_off,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: () {
                        _remoteUids.clear();
                        _engine.leaveChannel();
                        Navigator.pop(context);
                        if (!widget.isCalling) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.call_end,
                        size: 30,
                        color: Color.fromARGB(255, 255, 45, 30),
                      )),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget renderRemoteView(context) {
    if (_remoteUids.isNotEmpty) {
      if (_remoteUids.length == 1) {
        return Stack(
          children: [
            RtcRemoteView.SurfaceView(
                uid: _remoteUids.first, channelId: widget.channelName),
            const Positioned(
                bottom: 5,
                left: 5,
                child: Text(
                  '',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ))
          ],
        );
      } else if (_remoteUids.length == 2) {
        return Column(
          children: [
            Stack(
              children: [
                RtcRemoteView.SurfaceView(
                    uid: _remoteUids[0], channelId: widget.channelName),
                const Positioned(
                    bottom: 5,
                    left: 5,
                    child: Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ))
              ],
            ),
            Stack(
              children: [
                RtcRemoteView.SurfaceView(
                    uid: _remoteUids[1], channelId: widget.channelName),
                const Positioned(
                    bottom: 5,
                    left: 5,
                    child: Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ))
              ],
            )
          ],
        );
      } else {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 11 / 20,
                crossAxisSpacing: 5,
                mainAxisExtent: 10),
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    RtcRemoteView.SurfaceView(
                        uid: _remoteUids[index], channelId: widget.channelName),
                    const Positioned(
                        bottom: 5,
                        left: 5,
                        child: Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              );
            },
          ),
        );
      }
    } else {
      return const Text('Waiting For Members To Join');
    }
  }
}
