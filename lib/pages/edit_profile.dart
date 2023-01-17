import 'package:flutter/material.dart';

import '../common/custom_textFormField.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();
  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(236, 239, 239, 244),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 213,
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
                            backgroundImage:
                                AssetImage("assets/images/chat_avatar.png"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
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
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  CustomTextField(
                    controller: nameController,
                    validator: (value) {
                      print('value $value');
                      if (value == null || value.isEmpty) {
                        return 'Enter your First Name';
                      }

                      return null;
                    },
                    hintText: "Aditya Paswan",
                    keyboardType: TextInputType.name,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Divider(
                      thickness: 1,
                      height: 1,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              "PHONE NUMBER",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          // Divider(
          //   thickness: 2,
          //   height: 0,
          // ),
          CustomTextField(
            controller: nameController,
            validator: (value) {
              print('value $value');
              if (value == null || value.isEmpty) {
                return 'Enter your First Name';
              }

              return null;
            },
            hintText: "+99767869370",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              "ABOUT",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          // Divider(
          //   thickness: 2,
          //   height: 0,
          // ),
          CustomTextField(
            controller: nameController,
            validator: (value) {
              print('value $value');
              if (value == null || value.isEmpty) {
                return 'Enter your First Name';
              }

              return null;
            },
            hintText: "Digital goodies designer - Pixsellz",
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
