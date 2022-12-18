import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../common/global_variables.dart';
import '../controllers/authController.dart';

class OtpFieldWidget extends StatefulWidget {
  const OtpFieldWidget({Key? key, required this.otp_form_key})
      : super(key: key);
  final GlobalKey<FormState> otp_form_key;

  @override
  State<OtpFieldWidget> createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<OtpFieldWidget> {
  final authController = Get.put((AuthController()));

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.otp_form_key,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    authController.enteredOtp.value += val;
                  },
                  style: TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        EdgeInsets.only(top: 30, bottom: 30, left: 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              const VerticalDivider(
                color: AppColors.backgroundGrayLight,
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    authController.enteredOtp.value += val;
                  },
                  style: TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        EdgeInsets.only(top: 30, bottom: 30, left: 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              const VerticalDivider(
                color: AppColors.backgroundGrayLight,
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    authController.enteredOtp.value += val;
                  },
                  style: TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        EdgeInsets.only(top: 30, bottom: 30, left: 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              const VerticalDivider(
                color: Color.fromARGB(255, 219, 219, 219),
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    authController.enteredOtp.value += val;
                  },
                  style: TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        EdgeInsets.only(top: 30, bottom: 30, left: 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              const VerticalDivider(
                color: AppColors.backgroundGrayLight,
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                    authController.enteredOtp.value += val;
                  },
                  style: const TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        EdgeInsets.only(top: 30, bottom: 30, left: 30),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
