import 'dart:io';

import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class SendFileMessageWidget extends StatelessWidget {
  SendFileMessageWidget({
    super.key,
  });

  final chatsController = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Container(
              color: Colors.green,
              width: 4,
            ),
            const SizedBox(width: 8),
            Expanded(child: buildReplyMessage()),
          ],
        ),
      );

  Widget buildReplyMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chatsController.isSelectedFileImage.value)
              Expanded(
                  child: Image.file(
                File(chatsController.selectedFilePath.value),
                height: 200,
                fit: BoxFit.cover,
              ))
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.file_present_rounded,
                        color: AppColors.titleColorLight,
                      ),
                      const SizedBox(width: 5),
                      if (chatsController.selectedFileName.value.length > 40)
                        Text(
                          '${chatsController.selectedFileName.value.substring(0, 40)}...',
                          style: TextStyle(color: Colors.grey.shade900),
                        )
                      else
                        Text(chatsController.selectedFileName.value,
                            style: TextStyle(color: Colors.grey.shade900))
                    ],
                  ),
                ),
              ),
            const SizedBox(width: 4),
            GestureDetector(
              child: const Icon(Icons.close, size: 16),
              onTap: () {
                chatsController.selectedFilePath.value = '';
                chatsController.selectedFileName.value = '';

                chatsController.isSelectedFileImage.value = false;
              },
            )
          ],
        ),
      ],
    );
  }
}
