import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/CustomPopup.dart';
import 'package:sparrow/components/groupMsgCard.dart';
import 'package:sparrow/components/msgCard.dart';
import 'package:sparrow/components/pop-ups/msgMenuPopup.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/utils/basicapp-utils.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../common/global_variables.dart';

class AllStarredMessages extends StatefulWidget {
  const AllStarredMessages({super.key});

  @override
  State<AllStarredMessages> createState() => _AllStarredMessagesState();
}

class _AllStarredMessagesState extends State<AllStarredMessages> {
  final chatsController = Get.put(ChatsController());
  final userController = Get.put(UserController());

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    chatsController.fetchStarredMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final starredMessages = chatsController.allStarredMessages;

        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white60,
                ),
              ),
              title: const Text(
                "Starred Messages",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              backgroundColor: const Color.fromRGBO(11, 114, 102, 1),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (starredMessages.isEmpty || starredMessages == null) ...{
                  SvgPicture.asset(
                    "assets/icons/starred.svg",
                    height: 100,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "No Starred Messages",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  // ignore: equal_elements_in_set
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "Tap and hold on any message to star it, so you can easily find it later.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  )
                } else
                  Expanded(
                      child: Material(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 246, 246, 246),
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            itemCount: starredMessages.length,
                            itemBuilder: (context, index) {
                              final message = starredMessages[index];

                              return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomPopup(
                                              elements: Column(
                                            children: [
                                              if (message['sender'] ==
                                                  userController.user
                                                      .value['mobile']) ...{
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      chatsController
                                                          .onDeleteMsgFromStarredMsgs(
                                                              message['id']
                                                                  .toString());

                                                      // send msg_id to other member
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Text(
                                                          "Unsend Message",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .titleColorExtraLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons.call_received,
                                                          color: AppColors
                                                              .titleColorLight,
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
                                              },
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: message[
                                                                'message']));

                                                    toasterSuccessMsg(
                                                        'Copied To Clipboard');

                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        "Copy Text",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .titleColorExtraLight,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Icon(
                                                        Icons.copy,
                                                        color: AppColors
                                                            .titleColorLight,
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
                                              if (message['document'] !=
                                                  null) ...{
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      BasicAppUtils()
                                                          .downloadFileFromUrl(
                                                              '${dotenv.env['SERVER_MEDIA_URI']}${message['document']['document']}');
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Text(
                                                          "Download File",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .titleColorExtraLight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons.download,
                                                          color: AppColors
                                                              .titleColorLight,
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
                                              },
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    chatsController
                                                        .onStarUnstartFromMsgStarredMsgs(
                                                            message['id']
                                                                .toString());

                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        message['isStarred']
                                                            ? "Un-Star Message"
                                                            : "Star Message",
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .titleColorExtraLight,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      const Icon(
                                                        Icons.star,
                                                        color: AppColors
                                                            .titleColorLight,
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
                                    child: GroupMsgCardComponent(
                                      id: message['id'].toString(),
                                      text: BasicAppUtils()
                                          .utf8convert(message['message']),
                                      time:
                                          DateTime.parse(message['created_at']),
                                      isStarred: message['isStarred'],
                                      from: message['sender'],
                                      fromName: message['senderName'],
                                      document: message['document'],
                                      replyOf: message['replyOf'],
                                    ),
                                  ));
                            },
                          )))
              ],
            ));
      },
    );
  }
}
