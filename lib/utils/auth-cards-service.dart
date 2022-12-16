import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> featchTokenIfExpired(Map mapRes) async {
  try {
    if (mapRes['messages'][0]['message'].contains('expired')) {
      // check for refresh token expire, if not expired then featch new token
      final authCards = await CacheStorage().getAuthCards();
      var refresh = authCards['refresh'];

      Map<String, dynamic> refreshDecoded = JwtDecoder.decode(refresh);
      bool isRefreshExp = JwtDecoder.isExpired(refresh);

      if (isRefreshExp) {
        // move to login
        CacheStorage().removeAuthCards();
      }

      return true;
    }
    return false;
  } catch (_) {
    return false;
  }
}

featchAuthCards() async {
  try {} catch (_) {}
}
