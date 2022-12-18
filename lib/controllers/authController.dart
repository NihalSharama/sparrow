import 'package:sparrow/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class AuthController extends GetxController {
  var phoneController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();
  var enteredOtp = ''.obs;
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

    final isNoError = await AuthServices.featchSignUpOtp(phoneController.text,
        firstNameController.text, lastNameController.text);
    showOtp.value = isNoError;
  }

  onVerifyOtp(formkey) async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    enteredOtp.value = '';

    print(enteredOtp.value);

    final isNoError =
        await AuthServices().verifyOtp(phoneController.text, enteredOtp.value);

    return isNoError;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
