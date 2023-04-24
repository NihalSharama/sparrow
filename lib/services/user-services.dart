import 'dart:convert';
import 'dart:io';

import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserServices {
  updateProfile(Object newDetails) async {
    try {
      final response = await RequestMethods.postMethod(
          '/profile/update-profile/', newDetails, true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Update Profile');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      return mapRes['data']['data'];
    } catch (_) {}
  }

  updateProfilePic(String newProfilePic, String userId) async {
    try {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];

      var request = await http.MultipartRequest('POST',
          Uri.parse('${dotenv.env['SERVER_URI']}/profile/update-profile-pic/'));
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      request.headers.addEntries(headers.entries);

      request.files.add(http.MultipartFile(
          'profile_pic',
          File(newProfilePic).readAsBytes().asStream(),
          File(newProfilePic).lengthSync(),
          filename:
              'profile-$userId-$newProfilePic')); // use userid status-file-uid

      var response = await request.send();

      if (response.statusCode == 200) {
        toasterSuccessMsg('Profile Pic Updated Successfully');
        return true;
      } else {
        toasterFailureMsg('Faild To Update Profile Pic');
        return false;
      }
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  deleteProfilePic() async {
    final response =
        await RequestMethods.deleteMethod('/profile/remove-profile-pic/', true);
    if (response.statusCode != 200) {
      toasterFailureMsg('Failed To Remove Profile');
    }

    final Map<String, dynamic> mapRes = json.decode(response.body);
    toasterHandler(mapRes);

    print(mapRes);
    return mapRes['success'];
  }

  featchOtp(Object data) async {
    final response =
        await RequestMethods.postMethod('/profile/send_otp/', data, false);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return false;
    }

    final mapRes = json.decode(response.body);
    final isNoError = toasterHandler(mapRes);

    print(mapRes);

    return mapRes;
  }

  verifyOtp(Map data) async {
    final response =
        await RequestMethods.postMethod('/profile/verify_otp/', data, false);

    if (response.statusCode == 500) {
      toasterUnknownFailure();
      return false;
    }
    final mapRes = json.decode(response.body);

    toasterHandler(mapRes);

    return mapRes;
  }
}
