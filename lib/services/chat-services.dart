import 'dart:convert';

import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';

class ChatServices {
  featchChats() async {
    final response = await RequestMethods.getMethod('/chat/conv/', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    print(mapRes['data']);
    // return mapRes['data'];
  }

  featchChatDetails(String id) async {
    final response = await RequestMethods.getMethod('/chat/conv/$id', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    print(mapRes['data']);
    return;
  }

  sendChatMsg(String mobile, String msg) async {
    final response = await RequestMethods.postMethod(
        '/chat/conv/', {'mobile': mobile, 'msg': ''}, true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }

    final mapRes = json.decode(response.body);

    print(mapRes['data']);
    return;
  }
}
