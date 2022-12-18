import 'dart:convert';

import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';
import 'package:http/http.dart';

class AuthServices {
  featchLoginOtp(String mobile) async {
    final response = await RequestMethods.postMethod(
        '/auth/send_otp/', {'mobile': mobile}, false);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return false;
    }

    final mapRes = json.decode(response.body);
    final isNoError = toasterHandler(mapRes);

    print(mapRes);

    return isNoError;
  }

  featchSignUpOtp(String mobile, String firstName, String lastName) async {
    final response = await RequestMethods.postMethod(
        '/auth/send_otp/',
        {'mobile': mobile, 'first_name': firstName, 'last_name': lastName},
        false);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return false;
    }

    final mapRes = json.decode(response.body);
    final isNoError = toasterHandler(mapRes);

    print(mapRes);

    return isNoError;
  }

  verifyOtp(String mobile, String otp) async {
    final response = await RequestMethods.postMethod(
        '/auth/verify_otp/', {'mobile': mobile, 'otp': otp}, false);

    if (response.statusCode == 500) {
      toasterUnknownFailure();
      return false;
    }
    final mapRes = json.decode(response.body);

    final isNoError = toasterHandler(mapRes);

    CacheStorage().saveAuthCards(mapRes['data']);

    return isNoError;
  }

  featchAuthCardsFromRefresh() async {
    try {
      final authCard = await CacheStorage().getAuthCards();
      final refresh = authCard['referesh'];

      Response response = await RequestMethods.postMethod(
          '/token/refresh/', {'refresh': refresh}, false);

      final mapRes = json.decode(response.body);
      return mapRes;
    } catch (e) {
      toasterUnknownFailure();
    }
  }
}
