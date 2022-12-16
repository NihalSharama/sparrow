import 'dart:convert';

import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';

class ChatServices {
  featchChats() async {
    final response = await RequestMethods.getMethod('/api/chat/conv/', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    print(mapRes['data']);
    return;
  }
}
