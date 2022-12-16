import 'package:get/state_manager.dart';

var featchedChats = [
  {
    "id": 1,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "sent",
  },
  {
    "id": 2,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "received",
  },
  {
    "id": 3,
    "avatar": "assets/images/chat_avatar.png",
    "name": "Nihal Sharma",
    "lastMsg":
        "Hey! How is Your business going brother? it is been a long time brother",
    "lastMsgDate": DateTime.now(),
    "msgStatus": "seen",
  },
];

var featchedChatRoomDetails = {
  "roomAvatar": "assets/images/chat_avatar.png",
  "roomName": "Nihal Sharma",
  "messages": [
    {
      "text": "Good Morning!",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "Japan Looks amazing!",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "Do you know what time is it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "It’s morning in Tokyo",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
    {
      "text": "What is the most popular meal in Japan?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "Do you like it?",
      "msgStatus": "seen",
      "from": "Nihal Sharma",
      "time": DateTime.now()
    },
    {
      "text": "I think top two are:",
      "msgStatus": "seen",
      "from": "you",
      "time": DateTime.now()
    },
  ]
};

class ChatsController extends GetxController {
  var chats = [].obs;
  var chatRoomDetails = {}.obs;

  getChats() async {
    chats.value = featchedChats;
  }

  getChatRoomDetails(String roomId) async {
    chatRoomDetails.value = featchedChatRoomDetails;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
