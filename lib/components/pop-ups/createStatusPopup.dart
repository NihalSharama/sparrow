import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/statusController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class CreateStatusPopup extends StatefulWidget {
  const CreateStatusPopup({super.key});
  @override
  State<CreateStatusPopup> createState() => _CreateStatusPopupState();
}

class _CreateStatusPopupState extends State<CreateStatusPopup> {
  final statusController = Get.put(StatusController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () async {
                await statusController.clickPhoto();
                Navigator.pop(context);

                // ignore: use_build_context_synchronously
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Click Photo",
                    style: TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.camera_enhance,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundGrayLight,
            thickness: 1.2,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () async {
                await statusController.shootVideo();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Shoot Video",
                    style: TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.camera,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundGrayLight,
            thickness: 1.2,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () async {
                await statusController.pickFromGallery();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Pick Photo",
                    style: TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.photo,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColors.backgroundGrayLight,
            thickness: 1.2,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () async {
                await statusController.pickVideo();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Pick Video",
                    style: TextStyle(
                        color: AppColors.titleColorExtraLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.video_camera_back,
                    color: AppColors.titleColorLight,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
