// import 'dart:html';
import "dart:convert";
import "package:sparrow/services/firebase-notifications.dart";
import "package:sparrow/utils/cache-manager.dart";
import "package:flutter_webrtc/flutter_webrtc.dart";
import "package:sdp_transform/sdp_transform.dart";
import 'package:sparrow/utils/webRtc/websocket.dart';

class WebRtc {
  // #WebSocket Connection
  String host = '';

  // WebRtc Renderers
  RTCVideoRenderer localVideoRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteVideoRenderer = RTCVideoRenderer();

  bool _offer = false;
  late RTCPeerConnection peerConnection;
  late MediaStream _localStream;
  late String recv_id;
  late SimpleWebSocket ws;
  Function(MediaStream stream)? onLocalStream;

  bool micMute = false;
  WebRtc(this.ws, this.recv_id);

  Map<String, Function> eventHandlers = {};

  void sendData(Map<String, dynamic> data) {
    ws.send(json.encode(data));
  }

  void init() async {
    await localVideoRenderer.initialize();
    await remoteVideoRenderer.initialize();
    // Intitialising WebSocket Events
    // initListeners();
  }

  Future<void> destroy() async {
    _localStream.getTracks().forEach((track) {
      track.stop();
    });
    localVideoRenderer.dispose();
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
    localVideoRenderer.srcObject = stream;
    return stream;
  }

  Future<RTCPeerConnection> createConnection() async {
    Map<String, dynamic> configuration = {
      "sdpSemantics": "plan-b",
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

    await pc.addStream(_localStream);
    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print("Sending Candidate -- ");
        sendData({
          "type": "rtc.candidate",
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
          "receiver": recv_id
        });
      }
      ;
    };

    return pc;
  }

  void turnOffVideoCall() {
    _localStream.getVideoTracks().forEach((track) {
      track.enabled = false;
    });

    var data = {
      "type": "rtc.remote",
      "receiver": recv_id,
      "isVideoEnabled": false
    };

    sendData(data);
  }

  void turnOnVideoCall() {
    _localStream.getVideoTracks().forEach((track) {
      track.enabled = true;
    });

    var data = {
      "type": "rtc.remote",
      "receiver": recv_id,
      "isVideoEnabled": true
    };

    sendData(data);
  }

  void turnSpeakerOn() {
    _localStream.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(true);
    });
  }

  void turnSpeakerOff() {
    _localStream.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(false);
    });
  }

  bool isFrontCamera = true;

  void switchCameraToFace() async {
    _localStream.getVideoTracks().forEach((track) async {
      await track.switchCamera();
    });
  }

  void initListeners() async {
    eventHandlers["offer"] = (data) async {
      dynamic session = data["sdp"];
      String sdp = write(session, null);

      RTCSessionDescription description =
          RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

      await peerConnection!.setRemoteDescription(description);

      Map<String, dynamic> answerSession = await createAnswer(peerConnection);

      var data_ = {
        "type": "answer",
        "receiver": recv_id,
        "sdp": answerSession,
      };
      sendData(data_);
    };

    eventHandlers["rtc.answer"] = (data) async {
      dynamic session = data["sdp"];
      String sdp = write(session, null);

      RTCSessionDescription description =
          RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

      await peerConnection.setRemoteDescription(description);
    };

    eventHandlers["rtc.candidate"] = (data) async {
      dynamic session = data;
      dynamic candidate = RTCIceCandidate(
          session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
      await peerConnection.addCandidate(candidate);
    };
  }

  Future<void> createOffer(
      RTCPeerConnection pc, bool isAudioCall, String receiverMobile) async {
    final authCards = await CacheStorage().getAuthCards();
    var callerInfo = authCards['user'];
    RTCSessionDescription description =
        await pc.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    // print(json.encode(session));
    _offer = true;
    pc.setLocalDescription(description);
    print("Sending data");

    var data = {
      "type": "rtc.offer",
      "sdp": session,
      "receiver": recv_id,
      "caller_mobile": callerInfo['mobile'].toString(),
      "audioCall": isAudioCall
    };

    sendData(data);

    try {
      FirebaseServices().sendPushNotification(
          receiverMobile,
          'notification.call',
          callerInfo['mobile'].toString(),
          {'audioCall': isAudioCall});
    } catch (_) {}
  }

  Future<Map<String, dynamic>> createAnswer(RTCPeerConnection pc) async {
    RTCSessionDescription description =
        await pc.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());

    pc.setLocalDescription(description);
    return session;
  }

  //Functionallitites

  void toogleMic(bool micEnabled) {
    if (_localStream != null) {
      bool enabled = _localStream.getAudioTracks()[0].enabled;
      _localStream.getAudioTracks()[0].enabled = micEnabled;
    }
  }

  void hangUp(callback) async {
    sendData({"type": "rtc.hangup", "receiver": recv_id});
    localVideoRenderer.srcObject = null;
    remoteVideoRenderer.srcObject = null;

    await destroy();
    // await peerConnection.close();
    callback?.call();
  }
}
