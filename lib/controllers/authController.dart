import 'package:sparrow/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sparrow/pages/conversation/chats.dart';

class AuthController extends GetxController {
  var phoneController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();
  final otpBoxControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var enteredOtp = ''.obs;
  var showOtp = false.obs;
  

  onGetLoginOtp(formkey) async {
    if (formkey != null) {
      final isValid = formkey.currentState!.validate();
      if (!isValid) {
        return;
      }
    }

    final isNoError =
        await AuthServices().featchLoginOtp(phoneController.text );
    showOtp.value = isNoError;
  }

  onGetSignUpOtp(formkey) async {
    if (formkey != null) {
      final isValid = formkey.currentState!.validate();
      if (!isValid) {
        return;
      }
    }

    final isNoError = await AuthServices().featchSignUpOtp(phoneController.text,
        firstNameController.text, lastNameController.text);
    showOtp.value = isNoError;
  }

  onVerifyOtp(formkey, context) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final isNoError =
        await AuthServices().verifyOtp(phoneController.text, enteredOtp.value);

    for (TextEditingController otpController in otpBoxControllers) {
      otpController.text = '';
    }
    enteredOtp.value = '';
    phoneController.text = '';

    if (isNoError) {
      showOtp.value = false;
      Navigator.pushReplacementNamed(
          context, '/landing/${ChatsScreen.routeName}');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
