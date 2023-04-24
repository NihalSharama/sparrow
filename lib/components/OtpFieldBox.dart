import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/authController.dart';

class OtpFieldBox extends StatefulWidget {
  final BuildContext context;
  final int boxPosition;
  const OtpFieldBox(
      {super.key, required this.context, required this.boxPosition});

  @override
  State<OtpFieldBox> createState() => _OtpFieldBoxState();
}

class _OtpFieldBoxState extends State<OtpFieldBox> {
  final authController = Get.put((AuthController()));
  @override
  Widget build(BuildContext context) {
    print(widget.boxPosition);
    return Obx(() {
      return SizedBox(
        width: 50,
        child: TextFormField(
          controller: authController.otpBoxControllers[widget.boxPosition - 1],
          // maxLength: 1,
          enabled: (authController.enteredOtp.value.length <= widget.boxPosition
              ? true
              : false),
          autofocus: true,
          keyboardType: TextInputType.number,
          onChanged: (val) {
            print('val: $val');
            if (val.length > 1) {
              authController.otpBoxControllers[widget.boxPosition - 1].text =
                  authController.otpBoxControllers[widget.boxPosition - 1].text
                      .substring(0, 1);

              FocusScope.of(widget.context).nextFocus();
            } else if (authController
                    .otpBoxControllers[widget.boxPosition - 1].text.length ==
                1) {
              FocusScope.of(widget.context).nextFocus();
              authController.enteredOtp.value +=
                  authController.otpBoxControllers[widget.boxPosition - 1].text;
              print(
                  'after: ${authController.otpBoxControllers[widget.boxPosition - 1].text}');
            } else if (val == '') {
              FocusScope.of(widget.context).previousFocus();
              authController.enteredOtp.value = authController.enteredOtp.value
                  .substring(0, authController.enteredOtp.value.length - 1);
            }
          },
          style: const TextStyle(height: 1.5, fontSize: 20),
          decoration: InputDecoration(
            counterText: "",
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
      );
    });
  }
}
