import 'dart:convert';
import 'dart:io';

import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/request-methods.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatServices {
  fetchChats() async {
    try {
      final response = await RequestMethods.getMethod('/chat/conv/', true);

      if (response.statusCode != 200) {
        toasterUnknownFailure();
      }

      final mapRes = json.decode(response.body);

      return mapRes['data']['data'];
    } catch (_) {}
  }

  fetchArchivedChats() async {
    try {
      final response =
          await RequestMethods.getMethod('/chat/conv/archived_chats/', true);

      if (response.statusCode != 200) {
        toasterUnknownFailure();
      }

      final mapRes = json.decode(response.body);

      return mapRes['data']['data'];
    } catch (_) {}
  }

  fetchChatDetails(String id) async {
    final response = await RequestMethods.getMethod('/chat/conv/$id/', true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  fetchChatDetailsFromMobile(String mobile) async {
    final response = await RequestMethods.postMethod(
        '/chat/conv/get_conv/', {'mobile': mobile}, true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  fetchGroupChatDetails(String id) async {
    final response = await RequestMethods.postMethod(
        '/chat/conv/get_group/', {'group_id': id}, true);
    if (response.statusCode != 200) {
      toasterUnknownFailure();
    }

    final mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  sendChatMsg(String mobile, String msg, Object? replyOf) async {
    final response = await RequestMethods.postMethod(
        '/chat/chats/',
        {
          'mobiles': [mobile],
          'message': msg,
          'replyof': replyOf
        },
        true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }

    final mapRes = json.decode(response.body);

    return mapRes;
  }

  sendGroupChatMsg(
      List mobiles, String msg, String groupId, Object? replyOf) async {
    final response = await RequestMethods.postMethod(
        '/chat/chats/',
        {
          'mobiles': mobiles,
          'message': msg,
          'group_id': groupId,
          'replyof': replyOf
        },
        true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }

    final mapRes = json.decode(response.body);

    return mapRes;
  }

  createGroup(
    List mobiles,
    List admins,
    String groupName,
  ) async {
    final response = await RequestMethods.postMethod(
        '/chat/conv/create_group/',
        {
          'group_name': groupName,
          'mobiles': mobiles,
          'admins': admins,
        },
        true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }

    print(response.body);

    final mapRes = json.decode(response.body);

    return mapRes['data'];
  }

  sendFile(String msgId, String file, bool isImageFile) async {
    try {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];

      var request = await http.MultipartRequest('POST',
          Uri.parse('${dotenv.env['SERVER_URI']}/chat/chats/send_file/'));
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      request.headers.addEntries(headers.entries);

      request.files.add(http.MultipartFile('document',
          File(file).readAsBytes().asStream(), File(file).lengthSync(),
          filename: 'document-$file')); // use userid status-file-uid

      request.fields
          .addAll({'message': msgId, 'isImageFile': isImageFile.toString()});

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        toasterSuccessMsg('File Sent Successfully');
        final mapRes = json.decode(resBody);

        print(mapRes['data']['data']);
        return mapRes['data']['data'];
      } else {
        toasterFailureMsg('Faild To Send File');
        return;
      }
    } catch (e) {
      print(e);
      toasterUnknownFailure();
      await deleteChatMsg(msgId);
    }
  }

  deleteChatMsg(String msgId) async {
    final response =
        await RequestMethods.deleteMethod('/chat/chats/$msgId/', true);

    if (response.statusCode != 204) {
      toasterUnknownFailure();
      return;
    }

    print(response.body);
  }

  starUnstartChatMsg(String msgId, bool isStarred) async {
    final response = await RequestMethods.postMethod(
        '/chat/chats/star_message/',
        {"message_id": msgId, "isStarred": isStarred},
        true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    } else {
      toasterSuccessMsg(isStarred ? 'Message Starred' : 'Message Un-Starred');
    }
    print(response.body);
  }

  archiveUnarchiveChat(
      String chatId, bool isArchive, bool isConversation) async {
    final response = await RequestMethods.postMethod(
        '/chat/conv/archive_unarchive_chat/',
        isConversation
            ? {"conv_id": chatId, "archive": isArchive}
            : {"group_id": chatId, "archive": isArchive},
        true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    } else {
      toasterSuccessMsg(isArchive ? 'Chat Archived' : 'Chat Un-Archived');
    }
    print(response.body);
  }

  msgStatusChanged(String msgId, String status) async {
    final response = await RequestMethods.postMethod(
        '/chat/chats/message_status/',
        {"message_id": msgId, "status": status},
        true);

    print(response.body);
  }

  updateGroupProfilePic(String newProfilePic, String groupId) async {
    try {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];

      var request = await http.MultipartRequest(
          'POST',
          Uri.parse(
              '${dotenv.env['SERVER_URI']}/chat/conv/update_group_profile/'));
      var headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      request.headers.addEntries(headers.entries);
      request.fields.addAll({'group_id': groupId});
      request.files.add(http.MultipartFile(
          'group_profile',
          File(newProfilePic).readAsBytes().asStream(),
          File(newProfilePic).lengthSync(),
          filename:
              'profile-$groupId-$newProfilePic')); // use userid status-file-uid

      var response = await request.send();

      var res = await response.stream.bytesToString();
      final mapRes = json.decode(res);
      print(mapRes);
      if (response.statusCode == 200) {
        toasterSuccessMsg('Group Profile Pic Updated');
        return mapRes['data'];
      } else {
        toasterFailureMsg('Faild To Update Group Profile Pic');
        return mapRes['data'];
      }
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  deleteGroupProfilePic(String groupId) async {
    try {
      final response = await RequestMethods.postMethod(
          '/chat/conv/remove_group_profile/', {'group_id': groupId}, true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Remove Group Profile Pic');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
      return mapRes['data'];
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  changeGroupDetails(Map details, String groupId) async {
    try {
      details['group_id'] = groupId;

      print(details);
      final response = await RequestMethods.postMethod(
          '/chat/conv/update_group/', details, true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Change Group details');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
      return mapRes['data'];
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  onDeleteConversation(String convId) async {
    try {
      final response =
          await RequestMethods.deleteMethod('/chat/conv/$convId/', true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Delete Conversation');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  onDeleteGroup(String groupId) async {
    try {
      final response = await RequestMethods.postMethod(
          '/chat/conv/delete_group/', {'group_id': groupId}, true);
      if (response.statusCode != 200) {
        toasterFailureMsg('Failed To Delete Group');
      }

      final Map<String, dynamic> mapRes = json.decode(response.body);
      toasterHandler(mapRes);

      print(mapRes);
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  fetchStarredMessages() async {
    final response =
        await RequestMethods.getMethod('/chat/chats/starred_messages/', true);

    if (response.statusCode != 200) {
      toasterUnknownFailure();
      return;
    }
    final Map<String, dynamic> mapRes = json.decode(response.body);
    return mapRes['data'];
  }
}
