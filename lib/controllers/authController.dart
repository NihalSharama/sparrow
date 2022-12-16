import 'package:sparrow/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class AuthController extends GetxController {
  var phoneController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();
  var showOtp = false.obs;

  onGetLoginOtp(formkey) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final isNoError = await AuthServices().featchLoginOtp(phoneController.text);
    showOtp.value = isNoError;
  }

  onGetSignUpOtp(formkey) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final isNoError = await AuthServices().featchSignUpOtp(phoneController.text,
        firstNameController.text, lastNameController.text);
    showOtp.value = isNoError;
  }

  onVerifyOtp(formkey) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final isNoError = await AuthServices()
        .verifyOtp(phoneController.text, otpController.text);

    return isNoError;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
