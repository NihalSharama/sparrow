import 'package:get/state_manager.dart';

var featchedCalls = [
  {
    "avatar": "assets/images/chat_avatar.png",
    "name": "Aditya Paswan",
    "call": "Incoming",
    "callStatus": "Incoming",
  },
  {
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "call": "Outgoing",
    "callStatus": "Incoming",
  },
  {
    "avatar": "assets/images/chat_avatar.png",
    "name": "Anurag Sharma",
    "call": "Missed",
    "callStatus": "missed",
  },
  {
    "avatar": "assets/images/chat_avatar.png",
    "name": "Shweta Choduray",
    "call": "Incoming",
    "callStatus": "Incoming",
  }
];

class CallsController extends GetxController {
  var calls = [].obs;
  getCalls() async {
    calls.value = featchedCalls;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
