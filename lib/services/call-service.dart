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

  createCallLog(String id, isOne2OneCall) async {
    try {
      final response = await RequestMethods.postMethod(
          '/chat/calls/create_log/',
          isOne2OneCall ? {'conv_id': id} : {'group_id': id},
          true);

      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Create Call Log');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
    } catch (e) {
      print(e);
      toasterFailureMsg('Failed To Create Call Log');
    }
  }

  removeCallLog(String id) async {
    try {
      final response = await RequestMethods.postMethod(
          '/chat/calls/remove_log/', {'log_id': id}, true);

      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Remove Log');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  removeAllCallLogs() async {
    try {
      final response = await RequestMethods.deleteMethod(
          '/chat/calls/remove_all_logs/', true);

      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Remove Logs');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  fetchCallLogs() async {
    try {
      final response =
          await RequestMethods.getMethod('/chat/calls/logs/', true);

      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Fetch Call Logs');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);

      print(mapRes);
      return mapRes['data'];
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }
}
