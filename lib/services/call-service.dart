import 'dart:convert';

import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';

class CallServices {
  callRecipient() async {
    final response = await RequestMethods.getMethod('/chat/conv/', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    return mapRes['data']['data'];
  }
}
