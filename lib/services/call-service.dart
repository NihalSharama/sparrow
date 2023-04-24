import 'dart:convert';

import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';

class CallServices {
  featchAvailableUsersFromContacts(List numbers_list) async {
    try {
      final response = await RequestMethods.postMethod(
          '/chat/conv/get_available_users/',
          {'numbers_list': numbers_list},
          true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Featch Users From Contacts');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      return mapRes['data'];
    } catch (_) {}
  }
}
