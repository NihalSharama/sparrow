import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:sparrow/services/chat-services.dart';
import 'package:sparrow/services/status-services.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class StatusController extends GetxController {
  final replyStatusInput = TextEditingController();

  var myStatus = [].obs;
  var contactStatuses = [].obs;
  var statusViewers = [].obs;
  var postedByName = ''.obs;
  var currentStatusId = ''.obs;
  var currentStatusUrl = ''.obs;
  var currentStatusTimestamp = ''.obs;

  pickFromGallery() async {
    final FilePickerResult? files = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (files == null) {
      toasterFailureMsg('Failed To Pick Image');
      return;
    }

    var pickedFiles = <String>[];

    for (PlatformFile file in files.files) {
      pickedFiles.add(file.path!);
    }

    await StatusServices().uploadStatus2Server(pickedFiles);

    await getStatus();
  }

  clickPhoto() async {
    final XFile? clickedPhoto =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (clickedPhoto != null) {
      await StatusServices().uploadStatus2Server([clickedPhoto.path]);
      print('uploaded');

      await getStatus();
    }
  }

  shootVideo() async {
    final XFile? shootedVideo = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 1),
    );

    if (shootedVideo != null) {
      await StatusServices().uploadStatus2Server([shootedVideo.path]);

      await getStatus();
    }
  }

  pickVideo() async {
    final XFile? pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      await StatusServices().uploadStatus2Server([pickedVideo.path]);

      await getStatus();
    }
  }

  getStatus() async {
    var authCards = await CacheStorage().getAuthCards();
    final mobile = authCards['user']['mobile'];
    final response = await StatusServices().featchStatus(mobile.toString());

    var fetchedMyStatuses = response['data']['my_status'];

    for (var status in fetchedMyStatuses) {
      for (var view in status['views']) {
        var viewerName = await getUserNameFromMobile(view['mobile'].toString());

        view['viewerName'] = viewerName;
      }
    }

    print(fetchedMyStatuses);
    myStatus.value = fetchedMyStatuses;

    // ignore: non_constant_identifier_names
    var contact_statuses = [];

    for (var contactStatus in response['data']['contact_status']) {
      for (var mobile in contactStatus.keys) {
        var username = await getUserNameFromMobile(mobile);

        var contactStatusObj = {};
        contactStatusObj.assign(username, contactStatus[mobile]);

        contact_statuses.add(contactStatusObj);
      }
    }

    contactStatuses.value = contact_statuses;
  }

  deleteStatus() async {
    var featchedViewers =
        await StatusServices().deleteStatus(currentStatusId.value);

    myStatus.removeWhere(
        (status) => status['id'].toString() == currentStatusId.value);
  }

  Future onReplyStatus(
      String fromMobile, String toMobile, Object statusReply) async {
    try {
      final msgSentRes = await ChatServices().sendChatMsg(
          toMobile, replyStatusInput.text, json.encode(statusReply));

      if (msgSentRes['status_code'] != 200) {
        toasterFailureMsg('Failed To Send Message');
      }

      dynamic msgObj = {
        'receivers_mobile': [toMobile],
        'sender': msgSentRes['data']['sender'],
        'senderMobile': fromMobile,
        'message': replyStatusInput.text,
        'created_at': msgSentRes['data']['created_at'],
        'status': msgSentRes['data']['status'],
        'isStarred': msgSentRes['data']['isStarred'],
        'replyOf': json.encode(statusReply),
        'event_type': 'chat.receive'
      };

      replyStatusInput.text = '';
      toasterSuccessMsg('Replied To Status');
      return {"success": true, "data": msgObj};
    } catch (e) {
      print(e);

      toasterUnknownFailure();
      return {
        "success": false,
      };
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
