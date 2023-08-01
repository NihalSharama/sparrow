import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/settings/settingPage.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/services/user-services.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var user = {}.obs;

  final usernameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  final otpBoxControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var showOtp = false.obs;
  var otp = ''.obs;
  var bgImage = ''.obs;
  var currentCall = ''.obs;

  updateUserProfile(
      GlobalKey<FormState> editNameFormKey,
      GlobalKey<FormState> editEmailFormKey,
      GlobalKey<FormState> editBioFormKey) async {
    // final isValid = editProfileFormKey.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }

    final updatedProfileDetails = {};
    if (usernameController.text.isNotEmpty) {
      var isValid = editNameFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      final firstlastName = usernameController.text.split(' ');

      updatedProfileDetails.assign('first_name', firstlastName[0]);
      updatedProfileDetails.assign(
          'last_name',
          (firstlastName.length > 1
              ? firstlastName
                  .getRange(1, firstlastName.length)
                  .reduce((value, element) => '$value $element')
              : ''));
    }

    if (emailController.text.isNotEmpty) {
      var isValid = editEmailFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      updatedProfileDetails.assign('email', emailController.text);
    }
    if (bioController.text.isNotEmpty) {
      var isValid = editBioFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      updatedProfileDetails.assign('bio', bioController.text);
    }

    var newProfileDetails =
        await UserServices().updateProfile(updatedProfileDetails);

    if (newProfileDetails != null) {
      print('res: ' + newProfileDetails.toString());

      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];
      final refresh = authCards['refresh'];

      CacheStorage().saveAuthCards(
          {'token': token, 'refresh': refresh, 'user': newProfileDetails});

      user.value = newProfileDetails;

      usernameController.text = '';
      emailController.text = '';
      bioController.text = '';
    }
  }

  changeProfilePic(bool isRemoveProfilePic) async {
    var isUpdatedSuccess;
    var newProfileName = 'default.jpg';
    if (isRemoveProfilePic) {
      // set profile_pic url: server_url/default.jpg
      isUpdatedSuccess = await UserServices().deleteProfilePic();
    } else {
      final XFile? profilePic =
          await _picker.pickImage(source: ImageSource.gallery);
      if (profilePic != null) {
        newProfileName = profilePic.name;
        isUpdatedSuccess = await UserServices()
            .updateProfilePic(profilePic.path, user['id'].toString());
      }
    }

    if (isUpdatedSuccess) {
      final authCards = await CacheStorage().getAuthCards();
      final token = authCards['token'];
      final refresh = authCards['refresh'];
      var updatedUser = authCards['user'];
      updatedUser['profile_pic'] = '/media/profilepics/$newProfileName';

      CacheStorage().saveAuthCards(
          {'token': token, 'refresh': refresh, 'user': updatedUser});

      user.value = updatedUser;
    }
  }

  onGetOtp(formkey, Object data) async {
    if (formkey != null) {
      final isValid = formkey.currentState!.validate();
      if (!isValid) {
        return;
      }
    }

    final res = await UserServices().featchOtp(data);
    otp.value = res['data']['otp'].toString();
    showOtp.value = res['success'];
  }

  onVerifyOtp(formkey, context, data) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final res = await UserServices().verifyOtp(data);

    for (TextEditingController otpController in otpBoxControllers) {
      otpController.text = '';
    }
    showOtp.value = false;

    if (res['success']) {
      if (data['action'] == 'change-number') {
        CacheStorage().saveAuthCards(res['data']);
        user.value = res['data']['user'];
        Navigator.pop(context);
      } else if (data['action'] == 'delete-user') {
        print(res);
        await CacheStorage().removeAuthCards();
        user.value = {};
        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
      }
    }
  }

  void getBgImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final dirpath = dir.path;
    final filePath = '$dirpath/sparrow_chat_background.png';

    bool doesFileExists = await io.File(filePath).exists();
    if (doesFileExists) {
      bgImage.value = filePath;
    }
  }

  logout() async {
    await CacheStorage().removeAuthCards();
    await FirebaseServices().removeTokenFromFirebase();
  }

  @override
  void onInit() async {
    getBgImage();
    super.onInit();
  }

  @override
  void onClose() {}
}
