import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/customITextField.dart';
import 'package:sparrow/components/otp_field.dart';
import 'package:sparrow/controllers/authController.dart';
import 'package:sparrow/controllers/userController.dart';

class SensitiveSettings extends StatefulWidget {
  final bool isChangeNumber;
  const SensitiveSettings({
    super.key,
    required this.isChangeNumber,
  });

  @override
  State<SensitiveSettings> createState() => _SensitiveSettingsState();
}

class _SensitiveSettingsState extends State<SensitiveSettings> {
  final userController = Get.put(UserController());
  final authController = Get.put(AuthController());
  final authFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.appBarColor,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
            title: Text(
                (widget.isChangeNumber
                    ? "Change you number"
                    : "Delete Account"),
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (userController.showOtp.value) ...{
                    const SizedBox(height: 140),
                    const Text(
                      'OTP VERIFICATION',
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Enter The OTP Sent To - ',
                          style: TextStyle(
                              color: AppColors.titleColorExtraLight,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          child: Text(
                            userController.phoneController.value.text,
                            style: const TextStyle(
                                color: AppColors.mainColor,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: OtpFieldWidget(
                        otp_form_key: otpFormKey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Haven't Recieved Code ? ",
                          style: TextStyle(
                              color: AppColors.titleColorExtraLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () async {
                            for (TextEditingController otpController
                                in userController.otpBoxControllers) {
                              otpController.text = '';
                            }
                            authController.enteredOtp.value = '';
                            if (widget.isChangeNumber) {
                              await userController.onGetOtp(null, {
                                "mobile": userController.user['mobile'],
                                "new_mobile":
                                    userController.phoneController.text,
                                "action": "change-number"
                              });
                            } else if (!widget.isChangeNumber) {
                              await userController.onGetOtp(null, {
                                "mobile": userController.phoneController.text,
                                "action": "delete-user"
                              });
                            }
                          },
                          child: const Text(
                            "Re-Send",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('OTP Is: ${userController.otp.value}'),
                    // ignore: equal_elements_in_set
                    const SizedBox(height: 40),
                  } else ...{
                    const SizedBox(
                      height: 10,
                    ),

                    // ignore: equal_elements_in_set
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          "Enter your ${widget.isChangeNumber ? 'new' : ''} mobile no & verify it to change mobile number",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 87, 87, 87))),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Form(
                      key: authFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Divider(
                            color: Color.fromARGB(255, 213, 213, 213),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("India",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600)),
                              SvgPicture.asset("assets/icons/Sharp.svg")
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 213, 213, 213),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("+91",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                                const VerticalDivider(
                                  color: Color.fromARGB(255, 213, 213, 213),
                                  thickness: 1,
                                  width: 20,
                                  indent: 15,
                                  endIndent: 15,
                                ),
                                Expanded(
                                    child: CustomTextField(
                                        controller:
                                            userController.phoneController,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Enter your Moblie No.';
                                          } else if (val.length > 10 ||
                                              val.length < 10) {
                                            return 'Length should have 10 digits';
                                          }
                                          return null;
                                        },
                                        hintText: widget.isChangeNumber
                                            ? 'New Mobile number'
                                            : 'Enter Current Mobile ',
                                        keyboardType: TextInputType.phone))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  },
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomButton(
                          onPressed: () async {
                            if (userController.showOtp.value) {
                              if (widget.isChangeNumber) {
                                await userController
                                    .onVerifyOtp(otpFormKey, context, {
                                  'mobile': userController.user['mobile'],
                                  'new_mobile': int.parse(
                                      userController.phoneController.text),
                                  'otp': int.parse(
                                      authController.enteredOtp.value),
                                  'action': 'change-number'
                                });
                              } else {
                                await userController
                                    .onVerifyOtp(otpFormKey, context, {
                                  'mobile': userController.user['mobile'],
                                  'otp': int.parse(
                                      authController.enteredOtp.value),
                                  'action': 'delete-user'
                                });
                              }
                              authController.enteredOtp.value = '';

                              for (TextEditingController otpController
                                  in userController.otpBoxControllers) {
                                otpController.text = '';
                              }
                            } else {
                              if (widget.isChangeNumber) {
                                await userController.onGetOtp(null, {
                                  "mobile": userController.user['mobile'],
                                  "new_mobile":
                                      userController.phoneController.text,
                                  "action": "change-number"
                                });
                              } else if (!widget.isChangeNumber) {
                                await userController.onGetOtp(null, {
                                  "mobile": userController.user['mobile'],
                                  "new_mobile":
                                      userController.phoneController.text,
                                  "action": "delete-user"
                                });
                              }
                            }
                          },
                          text: (userController.showOtp.value
                              ? 'VERIFY OTP'
                              : 'SEND OTP'),
                          width: 100,
                          height: 50),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
