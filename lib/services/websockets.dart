// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:web_socket_channel/io.dart';

class WebSockets {
  final chatsController = Get.put(ChatsController());
  static final WebSockets _singleton = WebSockets._internal();

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  IOWebSocketChannel? channel;
  late var channelStream = channel?.stream.asBroadcastStream();

  factory WebSockets() {
    return _singleton;
  }

  WebSockets._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    try {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];

      var channel = IOWebSocketChannel.connect(
          Uri.parse('${dotenv.env['WS_URI']}/ws/chat/'),
          headers: {'token': token, "origin": '${dotenv.env['WS_URI']}/'});

      // channel.stream.listen(
      //   (event) {},
      //   onDone: () async {
      //     print("Disconnected");
      //     initWebSocketConnection();
      //   },
      // // );
      // chatsController.socketChannel = channel;
      // chatsController.streamController = channel.stream.asBroadcastStream();

      // chatsController.streamController.listen((snapshot) {
      //   if (snapshot != null) {
      //     var payload = json.decode(snapshot);
      //     if (payload['event_type'] == 'chat.receive') {
      //       print(payload);
      //       chatsController.chatRoomDetails.update(
      //           'messages',
      //           (value) =>
      //               chatsController.chatRoomDetails.value['messages'] +
      //               [json.decode(snapshot)]);
      //     }
      //   }
      // });

      print("socket connection initializied");
    } catch (e) {
      print('faild to connect ws');
    }
    // channel?.sink.done.then((dynamic _) => _onDisconnected());
  }

  void _onDisconnected() {
    initWebSocketConnection();
  }
}
