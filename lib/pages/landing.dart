import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/components/pop-ups/createStatusPopup.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/statusController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/archivedChats.dart';
import 'package:sparrow/pages/auth.dart';
import 'package:sparrow/pages/calls.dart';
import 'package:sparrow/pages/conversation/chats.dart';
import 'package:sparrow/pages/settings/settingPage.dart';
import 'package:sparrow/pages/status.dart';
import 'package:sparrow/pages/usersFromContact.dart';
import 'package:sparrow/services/call-service.dart';
import 'package:sparrow/services/firebase-notifications.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/notification-api.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing/';
  // ignore: prefer_typing_uninitialized_variables

  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final userController = Get.put(UserController());
  final chatsController = Get.put(ChatsController());
  final socketController = Get.put(SocketController());
  final statusController = Get.put(StatusController());
  final callsController = Get.put(CallsController());
  int currentIndex = 1;

  bool isIncomingCall = false;

  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      final authCards = await CacheStorage().getAuthCards();
      userController.user.value = authCards['user'];
    });

    // Configuring user to Firebase
    FirebaseServices().requestPermission();
    FirebaseServices().getToken();

    SimpleWebSocket chatWS = socketController.chatWS_.value;

    chatWS.eventHandlers["chat.receive"] = (data) async {
      print(data);
      var senderName = await getUserNameFromMobile(data['senderMobile']);
      LocalNotificationService().showNotification(data['sender_id'], senderName,
          'Message: ${data['message']}', 'message notification');

      var senderConversationIndex = chatsController.chats.value.indexWhere(
          (chat) => chat['conv_mobile'].toString() == data['senderMobile']);

      chatsController.chats.value[senderConversationIndex]['last_message'] = {
        'message': data['message'],
        'status': data['status'],
        'timestamp': data['created_at'],
        'sender': data['sender']
      };
      chatsController.chats.refresh();
    };

    chatWS.eventHandlers["group.chat.receive"] = (data) async {
      print(data);
      var senderName = await getUserNameFromMobile(data['senderMobile']);
      var groupName = chatsController.chats
          .firstWhere((chat) => chat['id'] == data['group_id'])['group_name'];
      LocalNotificationService().showNotification(data['group_id'], groupName,
          '$senderName: ${data['message']}', 'message notification');

      var senderConversationIndex = chatsController.chats.value
          .indexWhere((chat) => chat['id'] == data['group_id']);

      chatsController.chats.value[senderConversationIndex]['last_message'] = {
        'message': data['message'],
        'status': data['status'],
        'timestamp': data['created_at'],
        'sender': data['sender'],
        'sender_id': data['sender_id']
      };
      chatsController.chats.refresh();
    };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 1);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: Column(
            children: [
              if (currentIndex == 0)
                AppBar(
                  elevation: 1,
                  backgroundColor: const Color(0xfff2f2f2),
                  centerTitle: true,
                  title: const Text('Status',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleColor)),
                  leading: const Icon(
                    Icons.donut_large,
                    color: Colors.grey,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateStatusPopup();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: AppColors.appBarColor,
                      ),
                    ),
                  ],
                )
              else if (currentIndex == 1)
                AppBar(
                  elevation: 1,
                  backgroundColor: const Color(0xfff2f2f2),
                  centerTitle: true,
                  title: const Text('Chats',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleColor)),
                  leading: const Icon(
                    Icons.chat_bubble,
                    color: Colors.grey,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, ArchivedChats.routeName),
                          child: const Icon(
                            Icons.edit_calendar_outlined,
                            color: AppColors.appBarColor,
                          )),
                    ),
                  ],
                )
              else if (currentIndex == 2)
                AppBar(
                  elevation: 1,
                  backgroundColor: const Color(0xfff2f2f2),
                  centerTitle: true,
                  title: const Text('Call Logs',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleColor)),
                  leading: const Icon(
                    Icons.data_saver_off_sharp,
                    color: Colors.grey,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomPopup(
                                    elements: Column(
                                  children: [
                                    Text(
                                      'Are you sure do you want to clear all call logs ? ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                    const SizedBox(height: 20),
                                    CustomButton(
                                      onPressed: () async {
                                        CallServices().removeAllCallLogs();

                                        callsController.calls.clear();

                                        Navigator.pop(context);
                                      },
                                      text: 'Clear Logs',
                                      color: AppColors.appBarColor,
                                    )
                                  ],
                                ));
                              },
                            );
                          },
                          child: const Icon(
                            Icons.delete,
                            color: AppColors.appBarColor,
                          )),
                    ),
                  ],
                )
              else if (currentIndex == 3)
                AppBar(
                  elevation: 1,
                  backgroundColor: const Color(0xfff2f2f2),
                  centerTitle: true,
                  title: const Text('Settings',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          color: AppColors.titleColor)),
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomPopup(
                                elements: Column(
                              children: [
                                Text(
                                  'Are you Sure do you want to Logout from the app ? ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  onPressed: () async {
                                    await userController.logout();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(
                                        context, AuthScreen.routeName);
                                  },
                                  text: 'Logout',
                                  color: AppColors.appBarColor,
                                )
                              ],
                            ));
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: 25,
                        color: AppColors.appBarColor,
                      ),
                    )
                  ],
                ),
              BottomNavigationBar(
                  selectedItemColor: AppColors.appBarColor,
                  unselectedItemColor: Colors.grey[500],
                  currentIndex: currentIndex,
                  elevation: 0,
                  onTap: (value) {
                    currentIndex = value;
                    _pageController.animateToPage(value,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear);
                    setState(() {});
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SvgPicture.asset(
                          "assets/icons/status.svg",
                          height: 26,
                          width: 26,
                          color: currentIndex == 0
                              ? AppColors.appBarColor
                              : Colors.grey[500],
                        ),
                      ),
                      label: 'Status',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: SvgPicture.asset(
                          'assets/icons/chats.svg',
                          color: currentIndex == 1
                              ? AppColors.appBarColor
                              : Colors.grey[500],
                        ),
                      ),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: SvgPicture.asset(
                          'assets/icons/calls.svg',
                          color: currentIndex == 2
                              ? AppColors.appBarColor
                              : Colors.grey[500],
                        ),
                      ),
                      label: 'Calls',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.manage_accounts_rounded,
                        size: 35,
                      ),
                      label: 'Settings',
                    ),
                  ])
            ],
          )),
      floatingActionButton: (currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, ContactUsers.routeName);
              },
              backgroundColor: AppColors.appBarColor,
              child: const Icon(Icons.add),
            )
          : null),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/icons/arrow-up.svg',
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/reels');
              },
              child: SvgPicture.asset(
                'assets/icons/play.svg',
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/explore');
                },
                child: SvgPicture.asset(
                  'assets/icons/explore.svg',
                  width: 100,
                ),
              ),
              label: ''),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          currentIndex = page;
          setState(() {});
        },
        children: const [
          // const SizedBox(height: 10),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         IconButton(
          //             icon: SvgPicture.asset(
          //               "assets/icons/status.svg",
          //               height: 26,
          //               width: 26,
          //               color: (widget.subRoute == 'status'
          //                   ? AppColors.appBarColor
          //                   : Colors.grey),
          //             ),
          //             onPressed: () {
          //               Navigator.pushReplacementNamed(
          //                   context, '/landing/${StatusScreen.routeName}');
          //             }),
          //         Text('Status',
          //             style: TextStyle(
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.w600,
          //                 color: (widget.subRoute == 'status'
          //                     ? AppColors.appBarColor
          //                     : Colors.grey)))
          //       ],
          //     ),
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         IconButton(
          //           icon: SvgPicture.asset(
          //             'assets/icons/chats.svg',
          //             color: (widget.subRoute == 'chats'
          //                 ? AppColors.appBarColor
          //                 : Colors.grey),
          //           ),
          //           onPressed: () {
          //             Navigator.pushReplacementNamed(
          //                 context, '/landing/${ChatsScreen.routeName}');
          //           },
          //         ),
          //         Text('Chats',
          //             style: TextStyle(
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.w600,
          //                 color: (widget.subRoute == 'chats'
          //                     ? AppColors.appBarColor
          //                     : Colors.grey)))
          //       ],
          //     ),
          //     // Column(
          //     //   mainAxisAlignment: MainAxisAlignment.center,
          //     //   children: [
          //     //     IconButton(
          //     //         icon: SvgPicture.asset(
          //     //           'assets/icons/calls.svg',
          //     //           color: (widget.subRoute == 'calls'
          //     //               ? AppColors.appBarColor
          //     //               : Colors.grey),
          //     //         ),
          //     //         onPressed: () {
          //     //           Navigator.pushReplacementNamed(
          //     //               context, '/landing/${CallsScreen.routeName}');
          //     //         }),
          //     //     Text('Calls',
          //     //         style: TextStyle(
          //     //             fontSize: 12,
          //     //             fontWeight: FontWeight.w600,
          //     //             color: (widget.subRoute == 'calls'
          //     //                 ? AppColors.appBarColor
          //     //                 : Colors.grey)))
          //     //   ],
          //     // ),
          //     Column(
          //       children: [
          //         IconButton(
          //             onPressed: () {
          //               Navigator.pushReplacementNamed(
          //                   context, '/landing/${SettingPage.routeName}');
          //             },
          //             icon: Icon(
          //               Icons.manage_accounts_rounded,
          //               size: 35,
          //               color: (widget.subRoute == 'setting'
          //                   ? AppColors.appBarColor
          //                   : Colors.grey),
          //             )),
          //         Text('User',
          //             style: TextStyle(
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.w600,
          //                 color: (widget.subRoute == 'setting'
          //                     ? AppColors.appBarColor
          //                     : Colors.grey)))
          //       ],
          //     )
          //   ],
          // ),
          StatusScreen(),
          ChatsScreen(),
          CallsScreen(),
          SettingPage(),
          // if (widget.subRoute == ChatsScreen.routeName) ...{
          //   const Expanded(child: ChatsScreen())
          // } else if (widget.subRoute == CallsScreen.routeName) ...{
          //   const Expanded(child: CallsScreen())
          // } else if (widget.subRoute == StatusScreen.routeName) ...{
          //   const Expanded(child: StatusScreen())
          // } else if (widget.subRoute == SettingPage.routeName) ...{
          // } else
        ],
      ),
    );
  }
}
