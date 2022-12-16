import 'package:client/common/global_variables.dart';
import 'package:client/components/customButton.dart';
import 'package:client/components/customITextField.dart';
import 'package:client/controllers/authController.dart';
import 'package:client/pages/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authController = Get.put(AuthController());
  final AuthFormKey = GlobalKey<FormState>();
  bool isRegister = false;

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
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Hey! 👋",
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 35, 35, 35),
                          fontWeight: FontWeight.w600)),
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
                    key: AuthFormKey,
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
                                  return 'Enter your first name';
                                } else if (val.length > 10) {
                                  return 'Length Too Long';
                                }
                                return null;
                              },
                              hintText: 'First Name',
                              keyboardType: TextInputType.text),
                          const SizedBox(height: 5),
                          CustomTextField(
                              controller: authController.lastNameController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter your Moblie No.';
                                } else if (val.length > 10) {
                                  return 'Length Too Long';
                                }
                                return null;
                              },
                              hintText: 'Last Name',
                              keyboardType: TextInputType.text),
                        },
                        if (authController.showOtp.value) ...{
                          CustomTextField(
                              controller: authController.otpController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter OTP Sent To You';
                                } else if (val.length > 5 || val.length < 5) {
                                  return 'OTP length Must be 5';
                                }
                                return null;
                              },
                              hintText: 'Enter OTP To Verify',
                              keyboardType: TextInputType.number),
                        },
                        const Divider(
                          color: Color.fromARGB(255, 213, 213, 213),
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              isRegister = !isRegister;
                            });
                          }),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              (isRegister
                                  ? 'Already have account? Login'
                                  : 'Dont have account? Register'),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        if (authController.showOtp.value) ...{
                          GestureDetector(
                            onTap: () async {
                              if (isRegister) {
                                await authController
                                    .onGetSignUpOtp(AuthFormKey);
                              } else if (!isRegister) {
                                await authController.onGetLoginOtp(AuthFormKey);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Resend OTP?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        },
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: CustomButton(
                                onPressed: () async {
                                  var isNoError = false;
                                  if (authController.showOtp.value) {
                                    isNoError = await authController
                                        .onVerifyOtp(AuthFormKey);
                                  } else if (isRegister) {
                                    await authController
                                        .onGetSignUpOtp(AuthFormKey);
                                  } else if (!isRegister) {
                                    await authController
                                        .onGetLoginOtp(AuthFormKey);
                                  }

                                  print(isNoError);

                                  if (isNoError) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(context,
                                        '/landing/${ChatsScreen.routeName}');
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
