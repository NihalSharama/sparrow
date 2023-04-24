import 'dart:math';

import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/state_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SocketController extends GetxController {
  String userid = Random().nextInt(10000).toString();
  late Rx<SimpleWebSocket> ws_;
  late Rx<SimpleWebSocket> chatWS_;

  SimpleWebSocket chatWSInit() {
    late SimpleWebSocket chatWS;
    chatWS = SimpleWebSocket('${dotenv.env['WS_URI']}/ws/chat/');
    // chatWS = SimpleWebSocket('ws://192.168.0.129:8000/ws/chat/');
    // Connecting
    chatWS.connect();

    // Adding Event Handlers
    chatWS.onMessage = (data) {
      String? eventType = data["event_type"];
      print("Firing event Chat " + eventType.toString());
      Function? eventFunc = chatWS.eventHandlers[eventType];
      eventFunc?.call(data);
    };

    chatWS.onClose = () async {
      Future.delayed(const Duration(milliseconds: 5000), () {
        chatWS.connect();
      });
    };

    return chatWS;
  }

  SimpleWebSocket signallingWSInit() {
    late SimpleWebSocket ws;
    ws = SimpleWebSocket('${dotenv.env['WS_URI']}/ws/signalling/');
    // ws = SimpleWebSocket('ws://192.168.0.129:8000/ws/signalling/');

    // Connecting
    ws.connect();

    print('connected');

    // Adding Event Handlers
    ws.onMessage = (data) {
      String? eventType = data["type"];
      print("Firing event Signalling " + eventType.toString());
      Function? eventFunc = ws.eventHandlers[eventType];
      eventFunc?.call(data);
    };

    return ws;
  }

  @override
  void onInit() async {
    // Inititalising WebSocket;
    late SimpleWebSocket ws;
    ws = signallingWSInit();

    late SimpleWebSocket chatWS;
    chatWS = chatWSInit();
    // Stting WebSocket Globally
    ws_ = ws.obs;
    chatWS_ = chatWS.obs;

    super.onInit();
  }

  // var ws_ = ws.obs;
}
