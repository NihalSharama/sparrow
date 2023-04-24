import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/customITextField.dart';
import 'package:sparrow/components/pop-ups/exitEditingProfilePopup.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();

  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    final editProfileFormKey = GlobalKey<FormState>();
    final editEmailKey = GlobalKey<FormState>();
    final editBioKey = GlobalKey<FormState>();
    final editNameKey = GlobalKey<FormState>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ExitEditingProfilePopup(
                    editBioFormKey: editBioKey,
                    editNameFormKey: editNameKey,
                    editEmailFormKey: editEmailKey,
                  );
                },
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Color.fromARGB(236, 239, 239, 244),
        body: SingleChildScrollView(
          child: Form(
            key: editProfileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      '${dotenv.env['SERVER_MEDIA_URI']}${userController.user['profile_pic']}'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomPopup(
                                            elements: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await userController
                                                      .changeProfilePic(false);

                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Pick From Gallery",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .titleColorExtraLight,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Icon(
                                                      Icons.photo,
                                                      color:
                                                          Colors.blue.shade300,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              color:
                                                  AppColors.backgroundGrayLight,
                                              thickness: 1.2,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  await userController
                                                      .changeProfilePic(true);

                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "Remove Profile Pic",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .titleColorExtraLight,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Icon(
                                                      Icons.delete,
                                                      color:
                                                          Colors.red.shade300,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: const [
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 240,
                                  height: 36,
                                  child: Text(
                                      "Enter your name and add an optional profile picture",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        Form(
                          key: editNameKey,
                          child: CustomTextField(
                            controller: userController.usernameController,
                            validator: (value) {
                              print('value $value');
                              if (value == null || value.isEmpty) {
                                return 'Enter Your Name';
                              }
                              if (value.length >= 20) {
                                return 'Name Should Be less than 20';
                              }

                              return null;
                            },
                            hintText: userController.user['first_name'] +
                                ' ' +
                                userController.user['last_name'],
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    "PHONE NUMBER",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: '+91 ${userController.user['mobile']}',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 237, 237, 237),
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 165, 165, 165),
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  controller: userController.mobileController,
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    "YOUR EMAIL",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Form(
                  key: editEmailKey,
                  child: CustomTextField(
                    controller: userController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Valid Email';
                      }

                      if (!(value.contains('.com') && value.contains('@'))) {
                        return 'Enter Valid Email';
                      }

                      return null;
                    },
                    hintText: userController.user['email'] == ''
                        ? 'your_email@example.com'
                        : userController.user['email'],
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    "ABOUT",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Form(
                  key: editBioKey,
                  child: CustomTextField(
                    controller: userController.bioController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter About Yourself';
                      }

                      if (value.length > 20) {
                        return 'Bio Should Be less than 20';
                      }

                      return null;
                    },
                    hintText: userController.user['bio'] == ''
                        ? 'Busy'
                        : userController.user['bio'],
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                      onPressed: () {
                        userController.updateUserProfile(
                            editNameKey, editEmailKey, editBioKey);
                      },
                      text: 'SAVE CHANGES'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
