import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparrow/pages/settings/starredMessage.dart';
import 'package:sparrow/services/chat-services.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ChatsController extends GetxController {
  var chats = [].obs;
  var chatRoomDetails = {}.obs;
  var inputMsg = TextEditingController().obs;
  var replyMessage = {}.obs;
  var activeStatus = ''.obs;
  var selectedFilePath = ''.obs;
  var selectedFileName = ''.obs;
  var isSelectedFileImage = false.obs;
  var allStarredMessages = [].obs;
  var archivedChats = [].obs;
  // ignore: prefer_typing_uninitialized_variables

  // calling page
  getChats() async {
    var featchedChats = await ChatServices().fetchChats();

    var withContactChats = [];
    for (var chat in featchedChats) {
      var username =
          await getUserNameFromMobile(chat['conv_mobile'].toString());

      if (chat['group_name'] == null) {
        withContactChats.add({
          'id': chat['id'],
          'conv_mobile': chat['conv_mobile'],
          'conv_name': username,
          'last_message':
              (chat['last_message'].isEmpty ? {} : chat['last_message']),
          'archivedBy': chat['archivedBy'],
          'created_at': chat['created_at'],
          'avatar': chat['avatar'],
          'user1': chat['user1'],
          'user2': chat['user2']
        });
      } else {
        withContactChats.add(chat);
      }
    }

    chats.value = withContactChats;
  }

  getArchivedChats() async {
    var featchedChats = await ChatServices().fetchArchivedChats();

    var withContactChats = [];
    for (var chat in featchedChats) {
      var username =
          await getUserNameFromMobile(chat['conv_mobile'].toString());

      if (chat['group_name'] == null) {
        withContactChats.add({
          'id': chat['id'],
          'conv_mobile': chat['conv_mobile'],
          'conv_name': username,
          'last_message':
              (chat['last_message'].isEmpty ? {} : chat['last_message']),
          'archivedBy': chat['archivedBy'],
          'created_at': chat['created_at'],
          'avatar': chat['avatar'],
          'user1': chat['user1'],
          'user2': chat['user2']
        });
      } else {
        withContactChats.add(chat);
      }
    }

    archivedChats.value = withContactChats;
  }

  getChatRoomDetails(String roomId) async {
    if (roomId.length == 10) {
      // means id is actually mobile number
      Map<String, dynamic> featchedRoomDetails =
          await ChatServices().fetchChatDetailsFromMobile(roomId);

      var username = await getUserNameFromMobile(roomId);

      if (featchedRoomDetails['exists']) {
        featchedRoomDetails = {
          'id': featchedRoomDetails['conv']['id'],
          'messages': featchedRoomDetails['conv']['messages'],
          'conv_name': username,
          'avatar': featchedRoomDetails['conv']['avatar'],
          'receiver_info': featchedRoomDetails['conv']['receiver_info'],
          'archivedBy': featchedRoomDetails['conv']['archivedBy'],
          'created_at': featchedRoomDetails['conv']['created_at'],
          'user1': featchedRoomDetails['conv']['user1'],
          'user2': featchedRoomDetails['conv']['user2'],
          'exists': featchedRoomDetails['exists']
        };
      } else {
        featchedRoomDetails = {
          'conv_name': username,
          'messages': [],
          'receiver_info': {'mobile': roomId},
          'exists': featchedRoomDetails['exists']
        };
      }

      chatRoomDetails.value = featchedRoomDetails;
    } else {
      Map<String, dynamic> featchedRoomDetails =
          await ChatServices().fetchChatDetails(roomId);

      var username = await getUserNameFromMobile(
          featchedRoomDetails['receiver_info']['mobile'].toString());

      featchedRoomDetails = {
        'id': featchedRoomDetails['id'],
        'messages': featchedRoomDetails['messages'],
        'conv_name': username,
        'avatar': featchedRoomDetails['avatar'],
        'receiver_info': featchedRoomDetails['receiver_info'],
        'archivedBy': featchedRoomDetails['archivedBy'],
        'created_at': featchedRoomDetails['created_at'],
        'user1': featchedRoomDetails['user1'],
        'user2': featchedRoomDetails['user2'],
        'exists': true
      };
      chatRoomDetails.value = featchedRoomDetails;
    }
  }

  Future<void> getGroupChatRoomDetails(String groupId) async {
    Map<String, dynamic> featchedRoomDetails =
        await ChatServices().fetchGroupChatDetails(groupId);

    for (Map message in featchedRoomDetails['group']['messages']) {
      var senderName =
          await getUserNameFromMobile(message['sender'].toString());

      message.addEntries({'senderName': senderName}.entries);
    }

    chatRoomDetails.value = featchedRoomDetails['group'];
  }

  Future<bool> onCreateGroupChat(
      String groupName, List mobiles, List admins) async {
    try {
      Map<String, dynamic> featchedRoomDetails =
          await ChatServices().createGroup(mobiles, admins, groupName);

      chatRoomDetails.value = featchedRoomDetails;
      return featchedRoomDetails['created'];
    } catch (e) {
      return false;
    }
  }

  Future<Map> onSendChatMsg(String fromMobile) async {
    try {
      final msgSentRes = await ChatServices().sendChatMsg(
          chatRoomDetails.value['receiver_info']['mobile'].toString(),
          inputMsg.value.text == '' ? ' ' : inputMsg.value.text,
          (selectedFilePath.value.isEmpty
              ? (replyMessage.value.isEmpty)
                  ? null
                  : json.encode({
                      "reply_type": "reply.chat",
                      "reply_message": replyMessage['message'],
                      "replyTo_id": replyMessage['id'],
                      "replyTo_user": replyMessage['sender'],
                    })
              : null));

      if (msgSentRes['status_code'] != 200) {
        toasterFailureMsg('Failed To Send Message');
        return {
          "success": false,
        };
      }

      var fileResponse;
      if (selectedFilePath.value.isNotEmpty) {
        fileResponse = await ChatServices().sendFile(
            msgSentRes['data']['id'].toString(),
            selectedFilePath.value,
            isSelectedFileImage.value);
      }

      dynamic msgObj = {
        'id': msgSentRes['data']['id'],
        'recievers': msgSentRes['data']['receivers'],
        'receivers_mobile': [
          chatRoomDetails.value['receiver_info']['mobile'].toString()
        ],
        'sender': msgSentRes['data']['sender'],
        'sender_id': msgSentRes['data']['sender_id'],
        'senderMobile': fromMobile,
        'message': inputMsg.value.text == '' ? ' ' : inputMsg.value.text,
        'created_at': msgSentRes['data']['created_at'],
        'status': msgSentRes['data']['status'],
        'isStarred': msgSentRes['data']['isStarred'],
        'document': fileResponse,
        'replyOf': (replyMessage.value.isEmpty
            ? null
            : json.encode({
                "reply_type": "reply.chat",
                "reply_message": replyMessage['message'],
                "replyTo_id": replyMessage['id'],
                "replyTo_user": replyMessage['sender'],
              })),
        'event_type': 'chat.receive'
      };

      inputMsg.value.text = '';
      selectedFilePath.value = '';
      selectedFileName.value = '';
      isSelectedFileImage.value = false;

      chatRoomDetails.update(
          'messages', (value) => [msgObj] + chatRoomDetails.value['messages']);

      return {"success": true, "data": msgObj};
    } catch (e) {
      print(e);
      toasterUnknownFailure();
      return {
        "success": false,
      };
    }
  }

  Future<Map> onSendGroupChat(String fromMobile) async {
    try {
      var replyToName =
          await getUserNameFromMobile(replyMessage['sender'].toString());
      final msgSentRes = await ChatServices().sendGroupChatMsg(
          chatRoomDetails.value['users'],
          inputMsg.value.text == '' ? ' ' : inputMsg.value.text,
          chatRoomDetails.value['id'].toString(),
          (selectedFilePath.value.isEmpty
              ? (replyMessage.value.isEmpty)
                  ? null
                  : json.encode({
                      "reply_type": "reply.chat",
                      "reply_message": replyMessage['message'],
                      "replyTo_id": replyMessage['id'],
                      "replyTo_user": replyMessage['sender'],
                      "replyTo_name": replyToName,
                    })
              : null));

      if (msgSentRes['status_code'] != 200) {
        toasterFailureMsg('Failed To Send Message');
        return {
          "success": false,
        };
      }

      print(msgSentRes);

      var fileResponse;
      if (selectedFilePath.value.isNotEmpty) {
        fileResponse = await ChatServices().sendFile(
            msgSentRes['data']['id'].toString(),
            selectedFilePath.value,
            isSelectedFileImage.value);
      }

      chatRoomDetails.value['users'].remove(int.parse(fromMobile));

      dynamic msgObj = {
        'id': msgSentRes['data']['id'],
        'group_id': chatRoomDetails.value['id'],
        'receivers': msgSentRes['data']['receivers'],
        'receivers_mobile': chatRoomDetails.value['users'],
        'sender': msgSentRes['data']['sender'],
        'sender_id': msgSentRes['data']['sender_id'],
        'senderMobile': fromMobile,
        'message': inputMsg.value.text == '' ? ' ' : inputMsg.value.text,
        'created_at': msgSentRes['data']['created_at'],
        'status': msgSentRes['data']['status'],
        'isStarred': msgSentRes['data']['isStarred'],
        'document': fileResponse,
        'replyOf': (replyMessage.value.isEmpty
            ? null
            : json.encode({
                "reply_type": "reply.chat",
                "reply_message": replyMessage['message'],
                "replyTo_id": replyMessage['id'],
                "replyTo_user": replyMessage['sender'],
                "replyTo_name": replyToName,
              })),
        'event_type': 'group.chat.receive'
      };

      inputMsg.value.text = '';
      selectedFilePath.value = '';
      selectedFileName.value = '';
      isSelectedFileImage.value = false;

      chatRoomDetails.update(
          'messages', (value) => [msgObj] + chatRoomDetails.value['messages']);

      return {"success": true, "data": msgObj};
    } catch (e) {
      print(e);
      toasterUnknownFailure();
      return {
        "success": false,
      };
    }
  }

  Future<void> onDeleteMsg(String msgId) async {
    try {
      chatRoomDetails.value['messages'].removeWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      chatRoomDetails.update(
          'messages', (_) => chatRoomDetails.value['messages']);

      await ChatServices().deleteChatMsg(msgId);
    } catch (e) {
      toasterFailureMsg('Faild To Unsend Message');
    }
  }

  Future<void> onStarUnstartMsg(
    String msgId,
  ) async {
    try {
      var starredMessage = chatRoomDetails.value['messages'].firstWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      starredMessage['isStarred'] = !starredMessage['isStarred'];

      chatRoomDetails.update(
          'messages', (_) => chatRoomDetails.value['messages']);

      await ChatServices()
          .starUnstartChatMsg(msgId, starredMessage['isStarred']);
    } catch (e) {
      toasterFailureMsg('Faild To Star Message');
    }
  }

  Future<void> onArchiveUnacrchiveMsg(
      Map chat, bool isConversation, int userId) async {
    bool isArchive = !chat['archivedBy'].contains(userId);
    try {
      await ChatServices().archiveUnarchiveChat(
          chat['id'].toString(), isArchive, isConversation);

      if (isArchive) {
        chat['archivedBy'].add(userId);
        archivedChats.add(chat);
        chats.removeWhere((element) => element['id'] == chat['id']);
      } else {
        chat['archivedBy'].remove(userId);
        chats.add(chat);
        archivedChats.removeWhere((element) => element['id'] == chat['id']);
      }
    } catch (e) {
      toasterFailureMsg(
          "Faild To ${isArchive ? 'Archive' : 'Un-Archive'} Chat");
    }
  }

  Future<void> onDeleteMsgFromStarredMsgs(String msgId) async {
    try {
      allStarredMessages.removeWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      await ChatServices().deleteChatMsg(msgId);
    } catch (e) {
      toasterFailureMsg('Faild To Unsend Message');
    }
  }

  Future<void> onStarUnstartFromMsgStarredMsgs(
    String msgId,
  ) async {
    try {
      var starredMessage = allStarredMessages.firstWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      starredMessage['isStarred'] = !starredMessage['isStarred'];

      allStarredMessages.removeWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      await ChatServices()
          .starUnstartChatMsg(msgId, starredMessage['isStarred']);
    } catch (e) {
      toasterFailureMsg('Faild To Star Message');
    }
  }

  Future<void> onMsgStatusChanged(String msgId, String status) async {
    try {
      var messageSeen = chatRoomDetails.value['messages'].firstWhere((msg) {
        return msg['id'].toString() == msgId;
      });

      messageSeen['status'] = 'seen';

      chatRoomDetails.update(
          'messages', (_) => chatRoomDetails.value['messages']);

      await ChatServices().msgStatusChanged(msgId, status);
    } catch (e) {
      toasterFailureMsg('Faild To Star Message');
    }
  }

  Future<void> clickPhoto() async {
    final XFile? clickedPhoto =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (clickedPhoto != null) {
      selectedFilePath.value = clickedPhoto.path;
      selectedFileName.value = clickedPhoto.name;
      isSelectedFileImage.value = true;
    } else {
      toasterFailureMsg('Failed To Click Photo');
    }
  }

  void selectPhoto() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (file == null) {
      toasterFailureMsg('Failed To Pick Image');
      return;
    }

    selectedFilePath.value = file.files.first.path!;
    selectedFileName.value = file.files.first.name;
    isSelectedFileImage.value = true;
  }

  void selectDocument() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    if (pickedFile == null) {
      toasterFailureMsg('Failed To Pick Document');
      return;
    }

    selectedFilePath.value = pickedFile.files.first.path!;
    selectedFileName.value = pickedFile.files.first.name;
    isSelectedFileImage.value = false;
  }

  changeGroupProfilePic(bool isRemoveProfilePic) async {
    var updatedChatroom;
    var newProfileName = 'default-group.jpg';
    if (isRemoveProfilePic) {
      // set profile_pic url: server_url/default.jpg
      updatedChatroom = await ChatServices()
          .deleteGroupProfilePic(chatRoomDetails['id'].toString());
    } else {
      final XFile? profilePic =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (profilePic != null) {
        newProfileName = profilePic.name;
        updatedChatroom = await ChatServices().updateGroupProfilePic(
            profilePic.path, chatRoomDetails['id'].toString());
      }
    }

    for (Map message in updatedChatroom['messages']) {
      var senderName =
          await getUserNameFromMobile(message['sender'].toString());

      message.addEntries({'senderName': senderName}.entries);
    }

    chatRoomDetails.value = updatedChatroom;
  }

  changeGroupDetails(Map details, String groupId) async {
    try {
      final updatedChatroom =
          await ChatServices().changeGroupDetails(details, groupId);

      for (Map message in updatedChatroom['messages']) {
        var senderName =
            await getUserNameFromMobile(message['sender'].toString());

        message.addEntries({'senderName': senderName}.entries);
      }

      chatRoomDetails.value = updatedChatroom;
    } catch (e) {
      toasterFailureMsg('Failed To Change Group details');
    }
  }

  deleteConversation(String convId) async {
    try {
      await ChatServices().onDeleteConversation(convId);
    } catch (e) {
      toasterFailureMsg('Failed To Delete Conversation');
    }
  }

  deleteGroup(String GroupId) async {
    try {
      await ChatServices().onDeleteGroup(GroupId);
    } catch (e) {
      toasterFailureMsg('Failed To Delete Group');
    }
  }

  fetchStarredMessages() async {
    try {
      final starredMessages = await ChatServices().fetchStarredMessages();

      for (Map message in starredMessages) {
        final senderName =
            await getUserNameFromMobile(message['sender'].toString());
        message.addEntries({'senderName': senderName}.entries);
      }

      allStarredMessages.value = starredMessages;
    } catch (e) {
      toasterFailureMsg('Failed To Fetch Messages');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
