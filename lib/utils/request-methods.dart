import 'dart:convert';

import 'package:sparrow/services/auth-services.dart';
import 'package:sparrow/utils/auth-cards-service.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class RequestMethods {
  static var client = http.Client();

  static Future getMethod(String path, bool isAuth) async {
    final authCards = await CacheStorage().getAuthCards();
    var token = authCards?['token'];
    var response =
        await client.get(Uri.parse('${dotenv.env['SERVER_URI']}$path'),
            headers: (isAuth
                ? <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer $token',
                  }
                : <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  }));
    Map mapRes = json.decode(response.body);
    bool wasExpired = await featchTokenIfExpired(mapRes);

    if (wasExpired) {
      final newAuthCards = await AuthServices().featchAuthCardsFromRefresh();
      final newToken = newAuthCards['token'];
      CacheStorage().saveAuthCards(newAuthCards);

      response = await client.get(Uri.parse('${dotenv.env['SERVER_URI']}$path'),
          headers: (isAuth
              ? <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $newToken',
                }
              : <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                }));
    }

    return response;
  }

  static Future postMethod(String path, Object data, bool isAuth) async {
    final authCards = await CacheStorage().getAuthCards();
    var token = authCards?['token'];

    var response = await client.post(
      Uri.parse('${dotenv.env['SERVER_URI']}$path'),
      headers: (isAuth
          ? <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            }
          : <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            }),
      body: jsonEncode(data),
    );
    if (response.statusCode == 401) {
      Map mapRes = json.decode(response.body);
      bool wasExpired = await featchTokenIfExpired(mapRes);

      if (wasExpired) {
        final newAuthCards = await AuthServices().featchAuthCardsFromRefresh();
        final newToken = newAuthCards['token'];
        CacheStorage().saveAuthCards(newAuthCards);

        response =
            await client.post(Uri.parse('${dotenv.env['SERVER_URI']}$path'),
                headers: (isAuth
                    ? <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': 'Bearer $newToken',
                      }
                    : <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      }),
                body: jsonEncode(data));
      }
    }

    return response;
  }
}
