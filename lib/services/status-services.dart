import 'dart:convert';
import 'dart:io';

import 'package:sparrow/services/auth-services.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StatusServices {
  uploadStatus2Server(List<String> files) async {
    try {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];

      var request = await http.MultipartRequest(
          'POST', Uri.parse('${dotenv.env['SERVER_URI']}/status/statuses/'));
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      request.headers.addEntries(headers.entries);

      for (String file in files) {
        request.files.add(http.MultipartFile('media',
            File(file).readAsBytes().asStream(), File(file).lengthSync(),
            filename: 'status-$file')); // use userid status-file-uid
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        toasterSuccessMsg('Status Uploaded Successfully');
      } else {
        toasterFailureMsg('Faild To Uplaod Status');
      }
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  featchStatus(String mobile) async {
    final response =
        await RequestMethods.getMethod('/status/statuses/get-statuses/', true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }

    var mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  featchStatusViewers(id) async {
    final response = await RequestMethods.getMethod(
        '/status/statuses/status-views/$id', true);

    if (response.statusCode != 200) {
      return;
    }

    var mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  deleteStatus(String id) async {
    final response =
        await RequestMethods.deleteMethod('/status/statuses/$id/', true);

    if (response.statusCode != 204) {
      toasterFailureMsg('Failed To Delete Status');
    } else {
      toasterSuccessMsg('Status Deleted Successfully');
    }
  }

  viewStatus(String statusId) async {
    final response = await RequestMethods.postMethod(
        '/status/statuses/view_status/', {"status_id": statusId}, true);

    if (response.statusCode != 200) {
      return;
    }
  }
}
