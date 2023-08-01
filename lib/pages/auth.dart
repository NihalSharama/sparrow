import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/customITextField.dart';
import 'package:sparrow/components/otp_field.dart';
import 'package:sparrow/controllers/authController.dart';
import 'package:sparrow/controllers/userController.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authController = Get.put(AuthController());
  final userController = Get.put(UserController());
  final authFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  bool isRegister = false;

  @override
  initState() {
    // // CacheStorage().removeAuthCards();
    // // userController.user.value = {};
    // Future.delayed(Duration.zero, () async {
    //   final authCards = await CacheStorage().getAuthCards();

    //   bool invalidCreds;
    //   try {
    //     invalidCreds = (authCards['refresh'].toString() ==
    //             '[This field may not be null.]' ||
    //         authCards['token'].toString() == '[This field may not be null.]');
    //   } catch (_) {
    //     invalidCreds = (authCards == null || authCards.isEmpty);
    //   }

    //   if (!invalidCreds) {
    //     // ignore: use_build_context_synchronously
    //     Navigator.pushReplacementNamed(
    //         context, LandingScreen.routeName + ChatsScreen.routeName);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.appBarColor,
            centerTitle: true,
            title: Text((isRegister ? "Let's Get Started !" : "Welcome Back !"),
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
                  if (authController.showOtp.value) ...{
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
                            authController.phoneController.value.text,
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
                                in authController.otpBoxControllers) {
                              otpController.text = '';
                            }
                            authController.enteredOtp.value = '';
                            if (isRegister) {
                              await authController.onGetSignUpOtp(null);
                            } else if (!isRegister) {
                              await authController.onGetLoginOtp(null);
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
                    Text('OTP Is: ${authController.otp.value}'),
                    // ignore: equal_elements_in_set
                    const SizedBox(height: 40),
                  } else ...{
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Hey! 👋",
                        style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 35, 35, 35),
                            fontWeight: FontWeight.w600)),
                    // ignore: equal_elements_in_set
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          "Please confirm your country code and enter your phone number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                                      color: AppColors.appBarColor,
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
                                            authController.phoneController,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Enter your Moblie No.';
                                          } else if (val.length > 10 ||
                                              val.length < 10) {
                                            return 'Length should have 10 digits';
                                          }
                                          return null;
                                        },
                                        hintText: 'Mobile number',
                                        keyboardType: TextInputType.phone))
                              ],
                            ),
                          ),
                          if (isRegister == true) ...{
                            CustomTextField(
                              controller: authController.firstNameController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter Your First Name';
                                }
                                return null;
                              },
                              hintText: "First Name",
                              keyboardType: TextInputType.name,
                            ),
                            CustomTextField(
                              controller: authController.lastNameController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter Your Last Name';
                                }
                                return null;
                              },
                              hintText: "Last Name",
                              keyboardType: TextInputType.name,
                            )
                          },
                          const Divider(
                            color: Color.fromARGB(255, 213, 213, 213),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isRegister = !isRegister;
                              });
                              print(isRegister);
                            }),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                (isRegister
                                    ? 'Already have account? Login'
                                    : 'Dont have account? Register'),
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.appBarColor,
                                ),
                              ),
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
                            if (authController.showOtp.value) {
                              await authController.onVerifyOtp(
                                  otpFormKey, context);
                            } else if (isRegister) {
                              await authController.onGetSignUpOtp(authFormKey);
                            } else if (!isRegister) {
                              await authController.onGetLoginOtp(authFormKey);
                            }
                          },
                          text: (authController.showOtp.value
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
