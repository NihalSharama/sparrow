import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/customITextField.dart';
import 'package:sparrow/components/settingWidget.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:sparrow/pages/conversation/chats.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';
import 'package:sparrow/pages/landing.dart';
import 'package:sparrow/pages/settings/starredMessage.dart';

class ChatRoomInfo extends StatefulWidget {
  static const routeName = 'chat-info/';
  final String? id;
  const ChatRoomInfo({super.key, required this.id});

  @override
  State<ChatRoomInfo> createState() => _ChatRoomInfoState();
}

class _ChatRoomInfoState extends State<ChatRoomInfo> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());
  final groupNameController = TextEditingController();
  final newGroupMemberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isNotGroupChat = chatsController.chatRoomDetails['group_name'] == null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (!isNotGroupChat)
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomPopup(
                          elements: Column(
                        children: [
                          Text(
                            'Are you Sure do you want to exit the group \n  You may have some memories with it ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orange.shade700),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onPressed: () async {
                              chatsController.chatRoomDetails.value['users']
                                  .remove(userController.user['mobile']);
                              await chatsController.changeGroupDetails(
                                  {
                                    'users': chatsController
                                        .chatRoomDetails.value['users']
                                  },
                                  chatsController.chatRoomDetails['id']
                                      .toString());

                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(
                                  context,
                                  LandingScreen.routeName +
                                      ChatsScreen.routeName);
                            },
                            text: 'Exit',
                            color: Colors.red,
                          )
                        ],
                      ));
                    },
                  );
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red.shade300,
                )),
          if (isNotGroupChat)
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomPopup(
                          elements: Column(
                        children: [
                          Text(
                            'Are you Sure do you want to delete the conversation \n  You may have some memories with it ',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orange.shade700),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onPressed: () async {
                              chatsController.deleteConversation(chatsController
                                  .chatRoomDetails['id']
                                  .toString());

                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(
                                  context,
                                  LandingScreen.routeName +
                                      ChatsScreen.routeName);
                            },
                            text: 'Delete',
                            color: Colors.red,
                          )
                        ],
                      ));
                    },
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade300,
                ))
        ],
        leading: IconButton(
          onPressed: () {
            isNotGroupChat
                ? Navigator.pushReplacementNamed(
                    context,
                    ChatRoomScreen.routeName +
                        chatsController.chatRoomDetails['id'].toString())
                : Navigator.pushReplacementNamed(
                    context,
                    GroupChatRoomScreen.routeName +
                        chatsController.chatRoomDetails['id'].toString());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
        title: const Text(
          "Chat Info",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 375,
                      child: Image.network(
                        isNotGroupChat
                            ? '${dotenv.env['SERVER_MEDIA_URI']}${chatsController.chatRoomDetails['avatar']}'
                            : '${dotenv.env['SERVER_MEDIA_URI']}${chatsController.chatRoomDetails['group_profile']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (!isNotGroupChat &&
                        chatsController.chatRoomDetails.value['admins']
                            .contains(userController.user['mobile']))
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomPopup(
                                      elements: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await chatsController
                                                .changeGroupProfilePic(false);

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
                                                color: Colors.blue.shade300,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        color: AppColors.backgroundGrayLight,
                                        thickness: 1.2,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await chatsController
                                                .changeGroupProfilePic(true);

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
                                                color: Colors.red.shade300,
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
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 16,
                            )),
                      ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isNotGroupChat
                                    ? chatsController
                                        .chatRoomDetails['conv_name']
                                    : chatsController
                                                .chatRoomDetails['group_name']
                                                .length >
                                            25
                                        ? '${chatsController.chatRoomDetails['group_name'].substring(0, 25)}...'
                                        : chatsController
                                            .chatRoomDetails['group_name'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.titleColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              if (!isNotGroupChat &&
                                  chatsController
                                      .chatRoomDetails.value['admins']
                                      .contains(userController.user['mobile']))
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomPopup(
                                            elements: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CustomTextField(
                                              controller: groupNameController,
                                              validator: (val) {
                                                // if (val == null || val.isEmpty) {
                                                //   return 'Enter Group Name';
                                                // }
                                                // if (val.length > 20) {
                                                //   return 'Group Name To Long';
                                                // }
                                                return null;
                                              },
                                              hintText: 'Group Name',
                                              keyboardType: TextInputType.name,
                                            ),
                                            CustomButton(
                                              onPressed: () {
                                                chatsController
                                                    .changeGroupDetails(
                                                        {
                                                      'group_name':
                                                          groupNameController
                                                              .text
                                                    },
                                                        chatsController
                                                            .chatRoomDetails[
                                                                'id']
                                                            .toString());

                                                groupNameController.text = '';
                                                Navigator.pop(context);
                                              },
                                              text: 'Change',
                                              width: 100,
                                              height: 40,
                                            )
                                          ],
                                        ));
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 14),
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (isNotGroupChat) ...{
                            Text(
                              "+91 ${chatsController.chatRoomDetails['receiver_info']['mobile']}",
                              style: const TextStyle(
                                  color: AppColors.descriptionColorLight,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          }
                        ],
                      ),
                      const Divider(
                        color: AppColors.backgroundGrayLight,
                        thickness: 1.2,
                      ),
                      if (!isNotGroupChat)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Users',
                                  style: TextStyle(
                                      color: AppColors.titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                if (chatsController
                                    .chatRoomDetails.value['admins']
                                    .contains(userController.user['mobile']))
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          bool isNewMemberAdmin = false;
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return CustomPopup(
                                                  elements: Column(
                                                children: [
                                                  CustomTextField(
                                                      controller:
                                                          newGroupMemberController,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                      hintText:
                                                          'Enter Contact Number',
                                                      keyboardType:
                                                          TextInputType.number),
                                                  const SizedBox(height: 5),
                                                  CheckboxListTile(
                                                    title: const Text('Admin'),
                                                    value: isNewMemberAdmin,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isNewMemberAdmin =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomButton(
                                                      onPressed: () async {
                                                        print(isNewMemberAdmin);
                                                        if (isNewMemberAdmin) {
                                                          chatsController
                                                              .chatRoomDetails
                                                              .value['admins']
                                                              .add(
                                                                  newGroupMemberController
                                                                      .text);
                                                          await chatsController
                                                              .changeGroupDetails(
                                                                  {
                                                                'admins': chatsController
                                                                    .chatRoomDetails
                                                                    .value['admins']
                                                              },
                                                                  chatsController
                                                                      .chatRoomDetails[
                                                                          'id']
                                                                      .toString());
                                                        } else {
                                                          chatsController
                                                              .chatRoomDetails
                                                              .value['users']
                                                              .add(
                                                                  newGroupMemberController
                                                                      .text);
                                                          await chatsController
                                                              .changeGroupDetails(
                                                                  {
                                                                'users': chatsController
                                                                    .chatRoomDetails
                                                                    .value['users']
                                                              },
                                                                  chatsController
                                                                      .chatRoomDetails[
                                                                          'id']
                                                                      .toString());
                                                        }

                                                        newGroupMemberController
                                                            .text = '';
                                                        isNewMemberAdmin =
                                                            false;
                                                        setState(() {});

                                                        Navigator.pop(context);
                                                      },
                                                      text: 'Add User')
                                                ],
                                              ));
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      '(Add users)',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              height: chatsController.chatRoomDetails
                                          .value['users'].length >
                                      2
                                  ? MediaQuery.of(context).size.height * 0.3
                                  : 150,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: chatsController
                                    .chatRoomDetails.value['users'].length,
                                itemBuilder: (context, index) {
                                  var user = chatsController
                                      .chatRoomDetails.value['users'][index];
                                  bool isAdmin = chatsController
                                      .chatRoomDetails.value['admins']
                                      .contains(user);

                                  bool isUserYou =
                                      user == userController.user['mobile'];

                                  return ListTile(
                                      shape: const Border(
                                        //<-- SEE HERE
                                        bottom: BorderSide(width: 1),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                          isUserYou ? 'You' : user.toString()),
                                      subtitle: isAdmin
                                          ? const Text(
                                              "(Admin)",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : const Text(
                                              "(User)",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                      trailing:
                                          (chatsController.chatRoomDetails
                                                      .value['admins']
                                                      .contains(userController
                                                          .user['mobile']) &&
                                                  !isUserYou)
                                              ? IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomPopup(
                                                            elements: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  chatsController
                                                                      .chatRoomDetails
                                                                      .value[
                                                                          'users']
                                                                      .remove(
                                                                          user);
                                                                  await chatsController.changeGroupDetails(
                                                                      {
                                                                        'users': chatsController
                                                                            .chatRoomDetails
                                                                            .value['users']
                                                                      },
                                                                      chatsController
                                                                          .chatRoomDetails[
                                                                              'id']
                                                                          .toString());

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Remove From Group",
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .titleColorExtraLight,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Icon(
                                                                      Icons
                                                                          .exit_to_app,
                                                                      color: Colors
                                                                          .red
                                                                          .shade300,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color: AppColors
                                                                  .backgroundGrayLight,
                                                              thickness: 1.2,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  chatsController
                                                                      .chatRoomDetails
                                                                      .value[
                                                                          'admins']
                                                                      .add(
                                                                          user);
                                                                  await chatsController.changeGroupDetails(
                                                                      {
                                                                        'admins': chatsController
                                                                            .chatRoomDetails
                                                                            .value['admins']
                                                                      },
                                                                      chatsController
                                                                          .chatRoomDetails[
                                                                              'id']
                                                                          .toString());

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Assign Admin",
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .titleColorExtraLight,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Icon(
                                                                      Icons
                                                                          .shield_outlined,
                                                                      color: Colors
                                                                          .green
                                                                          .shade300,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            if (isAdmin)
                                                              Column(
                                                                children: [
                                                                  const Divider(
                                                                    color: AppColors
                                                                        .backgroundGrayLight,
                                                                    thickness:
                                                                        1.2,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        chatsController
                                                                            .chatRoomDetails
                                                                            .value['admins']
                                                                            .remove(user);
                                                                        await chatsController
                                                                            .changeGroupDetails({
                                                                          'admins': chatsController
                                                                              .chatRoomDetails
                                                                              .value['admins']
                                                                        }, chatsController.chatRoomDetails['id'].toString());

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const Text(
                                                                            "Remove As Admin",
                                                                            style:
                                                                                TextStyle(color: AppColors.titleColorExtraLight, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Icon(
                                                                            Icons.shield_outlined,
                                                                            color:
                                                                                Colors.orange.shade400,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          ],
                                                        ));
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                      Icons.more_vert))
                                              : null);
                                },
                              ),
                            )
                          ],
                        ),
                      if (isNotGroupChat)
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Design adds value faster, than it adds cost',
                                  style: TextStyle(
                                      color: AppColors.titleColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Dec 18, 2018",
                                  style: TextStyle(
                                      color: AppColors.descriptionColorLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // SettingWidget(
                //   svg: "assets/icons/gallery.svg",
                //   title: "Media, Links & Docs",
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const ChatMedia()));
                //   },
                // ),
                SettingWidget(
                  svg: "assets/icons/starred.svg",
                  title: "Starred Messages",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StarredMessage()));
                  },
                ),
                if (!isNotGroupChat &&
                    chatsController.chatRoomDetails['created_by'] ==
                        userController.user['id'])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPopup(
                                    elements: Column(
                                  children: [
                                    Text(
                                      'Are you Sure do you want to delete the Group \n  You may have some memories with it',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.orange.shade700),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      onPressed: () {
                                        chatsController.deleteGroup(
                                            chatsController
                                                .chatRoomDetails['id']
                                                .toString());

                                        Navigator.pushReplacementNamed(
                                            context,
                                            LandingScreen.routeName +
                                                ChatsScreen.routeName);
                                      },
                                      text: 'Delete',
                                      color: Colors.red,
                                    )
                                  ],
                                ));
                              });
                        },
                        text: 'Delete Group'),
                  )
                // SettingWidget(
                //   svg: "assets/icons/search.svg",
                //   title: "Chat Search",
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const StarredMessage()));
                //   },
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // SettingWidget(
                //   svg: "assets/icons/speaker.svg",
                //   title: "Mute",
                //   num: 'NO',
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const StarredMessage()));
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
