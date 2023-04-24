import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sparrow/controllers/basicAppController.dart';
import 'package:sparrow/utils/error-handlers.dart';

class BasicAppUtils {
  final basicAppController = Get.put(BasicAppController());

  downloadFileFromUrl(String url) async {
    try {
      final storagePerm = await Permission.storage.request();
      if (storagePerm.isGranted) {
        Dio dio = Dio();

        Directory? directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }

        var filename = url.split('/')[url.split('/').length - 1];

        final path = '${directory!.path}/$filename';
        print('download path: $path');

        await dio.download(url, path);
        toasterSuccessMsg('Downloaded Successfully');
      }
    } catch (e) {
      print(e);
      toasterFailureMsg('Failed To Download Image');
    }
  }

  String utf8convert(String text) {
    try {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    } catch (e) {
      return text;
    }
  }

  Future<void> incommingCallRing() async {
    await basicAppController.player.play(AssetSource("incomming-call.mp3"));

    basicAppController.player.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> stopIncommingCallRing() async {
    basicAppController.player.setReleaseMode(ReleaseMode.stop);
    await basicAppController.player.pause();
  }
}
