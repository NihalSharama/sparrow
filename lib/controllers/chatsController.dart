import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/state_manager.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:sparrow/services/chat-services.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:web_socket_channel/io.dart';

var featchedChats = [
  {
    "id": 1,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "sent",
  },
  {
    "id": 2,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "received",
  },
  {
    "id": 3,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "seen",
  },
];

var featchedChatRoomDetails = {
  "roomAvatar": "assets/images/chat_avatar.png",
  "roomName": "Nihal Sharma",
  "otherMobile": "1111111111",
  "messages": [
    {
      "text": "Good Morning!",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "Japan Looks amazing!",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "Do you know what time is it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "It’s morning in Tokyo",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "What is the most popular meal in Japan?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "Do you like it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "I think top two are:",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "It’s morning in Tokyo",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "What is the most popular meal in Japan?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "Do you like it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "I think top two are:",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "It’s morning in Tokyo",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "What is the most popular meal in Japan?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "Do you like it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "I think top two are:",
      "msgStatus": "sent",
      "from": "you",
      "time": DateTime.now()
    },
  ]
};

class ChatsController extends GetxController {
  var chats = [].obs;
  var chatRoomDetails = {}.obs;
  var inputMsg = TextEditingController().obs;
  // ignore: prefer_typing_uninitialized_variables
  late IOWebSocketChannel socketChannel;
  late Stream streamController;
  RTCPeerConnection? peerConnection;

  final localVideoRenderer = RTCVideoRenderer();
  final remoteVideoRenderer = RTCVideoRenderer();

  var offer = false.obs;
  var isVideoCall = false.obs;
  var answerData = {}.obs;
  var candidate = ''.obs;
  var callingStatus = ''.obs;
  var isAnswerSent = false.obs;

  MediaStream? localStream;
  MediaStream? remoteStream;

  getChats() async {
    try {
      var featchedChatsApi = await ChatServices().featchChats();
      // await ChatServices().featchChatDetails('1');

      chats.value = featchedChatsApi;
    } catch (e) {
      return;
    }
  }

  getChatRoomDetails(String roomId) async {
    var featchedRoomDetailsApi = await ChatServices().featchChatDetails(roomId);
    chatRoomDetails.value = featchedRoomDetailsApi;

    // socketChannel.stream.listen((event) {
    //   print(event);
    // chatRoomDetails.update('messages',
    //     (value) => chatRoomDetails.value['messages'] + [json.decode(event)]);
    // });
  }

  onSendChatMsg() async {
    try {
      final msgSentRes = await ChatServices().sendChatMsg(
          chatRoomDetails.value['receiver_info']['mobile'].toString(),
          inputMsg.value.text);

      if (msgSentRes['status_code'] != 200) {
        toasterFailureMsg('Failed To Send Message');
        return;
      }

      var msgObj = {
        'receiver_mobile':
            chatRoomDetails.value['receiver_info']['mobile'].toString(),
        'sender': msgSentRes['data']['sender'],
        'message': inputMsg.value.text,
        'created_at': msgSentRes['data']['created_at'],
        'status': msgSentRes['data']['status'],
        'isStarred': msgSentRes['data']['isStarred'],
        'event_type': 'chat.receive'
      };

      socketChannel.sink.add(json.encode(msgObj));

      chatRoomDetails.update(
          'messages', (value) => chatRoomDetails.value['messages'] + [msgObj]);

      inputMsg.value.text = '';
    } catch (e) {
      toasterUnknownFailure();
      return;
    }
  }

  addUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    localVideoRenderer.srcObject = stream;
    stream.getTracks().forEach((track) {
      peerConnection!.addTrack(track, stream);
    });

    return stream;
  }

  createPeerConnecion() async {
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

    // localStream = await addUserMedia();
    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    // pc.addStream(localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        var candidateData = {
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        };
        print(candidateData);

        if (!offer.value && !isAnswerSent.value) {
          var payload = {
            "event_type": "sdp.receive",
            "receiver_mobile": answerData.value['receiver_mobile'],
            "sdp": answerData.value['sdp'],
            "candidate": candidateData
          };

          print('answer data: $payload');
          socketChannel.sink.add(json.encode(payload));
          isAnswerSent.value = true;
        }
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      remoteVideoRenderer.srcObject = stream;
      print('stream: ${stream.id}');
    };

    peerConnection = pc;
  }

  createOffer() async {
    try {
      RTCSessionDescription description =
          await peerConnection!.createOffer({'offerToReceiveVideo': 1});
      var session = parse(description.sdp.toString());
      offer.value = true;

      peerConnection!.setLocalDescription(description);
      var payload = {
        'event_type': 'sdp.receive',
        'receiver_mobile':
            chatRoomDetails.value['receiver_info']['mobile'].toString(),
        'caller_mobile': '1111111111',
        'sdp': session
      };
      socketChannel.sink.add(json.encode(payload));
      print('offer: ${json.encode(payload)}');
      return payload;
    } catch (_) {
      toasterUnknownFailure();
    }
  }

  void createAnswer(String callerNumber) async {
    try {
      RTCSessionDescription description =
          await peerConnection!.createAnswer({'offerToReceiveVideo': 1});

      var session = parse(description.sdp.toString());

      peerConnection!.setLocalDescription(description);
      var answer = {
        'receiver_mobile': callerNumber,
        'sdp': session,
      };
      print('answer: ${json.encode(answer)}');
      answerData.value = answer;
      // socketChannel.sink.add(json.encode(payload));
    } catch (e) {
      toasterUnknownFailure();
    }
  }

  void setRemoteDescription(session) async {
    // String jsonString = sdpController.text;
    // dynamic session = await jsonDecode(sessionString);

    String sdp = write(session, null);
    RTCSessionDescription description =
        RTCSessionDescription(sdp, offer.value ? 'answer' : 'offer');
    print('description: ${description.toMap()}');

    await peerConnection!.setRemoteDescription(description);
  }

  void addCandidate(session) async {
    // String jsonString = sdpController.text;
    // dynamic session = await jsonDecode(sessionString);
    print('session : $session');
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await peerConnection!.addCandidate(candidate);
  }

  sdpExchange() {
    socketChannel.stream.listen((event) {
      var payload = json.decode(event);
      setRemoteDescription(payload['sdp']);
      if (offer.value == false) {
        createAnswer('1111111111');
      } else if (payload['candidate'] != null) {
        addCandidate(payload['candidate']);
      }
      return event;
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
