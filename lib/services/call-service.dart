import 'dart:convert';

import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';
import 'package:sparrow/utils/rtc-user.dart';

class CallServices {
  onCallStart() async {
    var userId = await loadUserId();

    final response = await RequestMethods.postMethod(
        '/calls/start/', {'hostId': userId, 'hostName': 'Nihal Sharma'}, true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);
    toasterHandler(mapRes);

    return mapRes['data'];
  }

  onCallJoin(String callId) async {
    var userId = await loadUserId();

    final response =
        await RequestMethods.getMethod('/calls/join?callId=$callId', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);
    toasterHandler(mapRes);

    return mapRes['data'];
  }

  onCallEnd() async {
    // final response = await RequestMethods.getMethod('/chat/conv/', true);
    // if (response.statusCode != 200) {
    //   toasterUnknownFailure();
    // }

    // final mapRes = json.decode(response.body);

    // return mapRes['data']['data'];
  }
}
