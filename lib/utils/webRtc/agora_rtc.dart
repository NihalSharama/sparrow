import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sparrow/controllers/userController.dart';

class AgoraRTC {
  final userController = Get.put(UserController());
  String? appId = dotenv.env['AGORA_APP_ID'];

  Future<void> groupCall() async {}
  Future<void> joinGroupCall(String channelName) async {}
}
