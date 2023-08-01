import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SimpleWebSocket {
  String _url;
  late WebSocketChannel _socket;
  Function(dynamic msg)? onMessage;
  Function()? onClose;
  Map<String, Function> eventHandlers = {};
  Function()? onOpen;
  Function()? onDisconnect;

  SimpleWebSocket(this._url);

  connect() async {
    try {
      //_socket = await WebSocket.connect(_url)

      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];
      final wsUrl = Uri.parse(_url);
      _socket = IOWebSocketChannel.connect(wsUrl,
          headers: {'token': token, "origin": '${dotenv.env['WS_URI']}/'});

      _socket.stream.listen((data) {
        data = json.decode(data);
        if (data["type"] == "connected") {
          onOpen?.call();
        } else {
          onMessage?.call(data);
        }
      }, onDone: () {
        // onClose?.call(_socket.closeCode, _socket.closeReason);
        onClose?.call();
      });
      print('connected');
    } catch (e) {
      // onClose?.call(500, e.toString());
      onClose?.call();
    }
  }

  send(data) {
    if (_socket != null) {
      _socket.sink.add(data);
      print('send: $data');
    }
  }

  close() {
    if (_socket != null) _socket.sink.close();
  }
}
