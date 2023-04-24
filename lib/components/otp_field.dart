import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/OtpFieldBox.dart';
import 'package:sparrow/controllers/userController.dart';

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
              OtpFieldBox(
                context: context,
                boxPosition: 1,
              ),
              const VerticalDivider(
                color: AppColors.backgroundGrayLight,
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              OtpFieldBox(
                context: context,
                boxPosition: 2,
              ),
              const VerticalDivider(
                color: AppColors.backgroundGrayLight,
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              OtpFieldBox(
                context: context,
                boxPosition: 3,
              ),
              const VerticalDivider(
                color: Color.fromARGB(255, 219, 219, 219),
                thickness: 1.2,
                indent: 10,
                endIndent: 10,
              ),
              OtpFieldBox(
                context: context,
                boxPosition: 4,
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
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (val.length == 1) {
                      FocusScope.of(context).nextFocus();
                      authController.enteredOtp.value += val;
                    } else if (val == '') {
                      FocusScope.of(context).previousFocus();
                      authController.enteredOtp.value =
                          authController.enteredOtp.value.substring(
                              0, authController.enteredOtp.value.length - 1);
                    }
                  },
                  style: const TextStyle(height: 1.5, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundGrayExtraLight,
                    contentPadding:
                        const EdgeInsets.only(top: 30, bottom: 30, left: 20),
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
