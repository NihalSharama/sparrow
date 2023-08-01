import 'dart:convert';

import 'package:sparrow/common/global_variables.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/socketController.dart';
import 'package:sparrow/controllers/statusController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/services/status-services.dart';
import 'package:sparrow/utils/user-contacts.dart';
import 'package:sparrow/utils/webRtc/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:story_view/story_view.dart';
import 'package:we_slide/we_slide.dart';

class StatusView extends StatefulWidget {
  final List stories;
  const StatusView({super.key, required this.stories});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final _storyController = StoryController();
  final userController = Get.put(UserController());
  final statusController = Get.put(StatusController());
  final socketController = Get.put(SocketController());
  final chatsController = Get.put(ChatsController());

  final List<StoryItem> storyItems = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var statusPostedBy = await getUserNameFromMobile(
          widget.stories[0]['user_mobile'].toString());

      if (widget.stories[0]['user_mobile'] != userController.user['mobile']) {
        statusController.postedByName.value = statusPostedBy;
      } else {
        statusController.postedByName.value = 'My Status';
      }
    });

    for (var story in widget.stories) {
      var storyExtention = path.extension(story['media']);

      if (storyExtention.isImageFileName) {
        storyItems.add(StoryItem.pageImage(
          key: Key(story['id'].toString()),
          url: '${dotenv.env['SERVER_MEDIA_URI']}${story['media']}',
          controller: _storyController,
          // imageFit: BoxFit.fill,
        ));
      } else if (storyExtention.isVideoFileName) {
        storyItems.add(StoryItem.pageVideo(
            '${dotenv.env['SERVER_MEDIA_URI']}${story['media']}',
            key: Key(story['id'].toString()),
            controller: _storyController,
            duration: const Duration(minutes: 1)));
      }
    }

    super.initState();
  }

  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WeSlide(
            panelMinSize: 30,
            panelMaxSize: MediaQuery.of(context).size.height / 2,
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                StoryView(
                  onComplete: () {
                    Navigator.pop(context);
                  },
                  onVerticalSwipeComplete: (p0) {},
                  onStoryShow: (status) async {
                    var id = status.view.key.toString().split("'")[1];

                    statusController.currentStatusId.value = id;

                    for (var story in widget.stories) {
                      if (story['id'].toString() == id) {
                        statusController.currentStatusUrl.value =
                            story['media'];

                        statusController.currentStatusTimestamp.value =
                            DateFormat('h:mma')
                                .format(DateTime.parse(story['created_at']));

                        if (widget.stories[0]['user'] ==
                            userController.user['id']) {
                          statusController.statusViewers.value = story['views'];
                        } else {
                          // view status
                          await StatusServices()
                              .viewStatus(story['id'].toString());
                        }
                      }
                    }
                  },
                  storyItems: storyItems,
                  controller: _storyController,
                  inline: false,
                  repeat: true,
                ),
                Positioned(
                  top: 20,
                  left: 15,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            '${dotenv.env['SERVER_MEDIA_URI']}${widget.stories[0]['user_profile']}'),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusController.postedByName.value,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statusController.currentStatusTimestamp.value,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.stories[0]['user'] != userController.user['id']) ...{
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Reply To Status',
                                  filled: true,
                                  fillColor: Color.fromARGB(143, 114, 114, 114),
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      left: 20.0, bottom: 8.0, top: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                controller: statusController.replyStatusInput,
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                var statusReply = {
                                  "reply_type": "reply.status",
                                  "reply_status": statusController
                                      .currentStatusUrl.value
                                      .toString(),
                                  "replyTo_id":
                                      statusController.currentStatusId.value,
                                  "replyTo_user": widget.stories[0]['user'],
                                };

                                var res = await statusController.onReplyStatus(
                                    userController.user['mobile'].toString(),
                                    widget.stories[0]['user_mobile'].toString(),
                                    statusReply);

                                if (res['success'] == true) {
                                  SimpleWebSocket chatWS =
                                      socketController.chatWS_.value;

                                  chatWS.send(json.encode(res['data']));
                                }

                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.send,
                                  color: Color.fromARGB(255, 214, 214, 214)))
                        ],
                      ),
                    ),
                  )
                },
              ],
            ),
            panel: (widget.stories[0]['user'] == userController.user['id']
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                                size: 24,
                              ),
                              Obx(
                                () => Text(
                                  statusController.statusViewers.length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                color: AppColors.appBarColor,
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Obx(
                                          () => Text(
                                            statusController
                                                .statusViewers.length
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Text(
                                      'VIEWS',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.share_rounded,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            statusController.deleteStatus();

                                            Navigator.pop(context);
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Obx(
                            () => Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(186, 73, 73, 73),
                              ),
                              child: ListView.builder(
                                itemCount:
                                    statusController.statusViewers.length,
                                itemBuilder: (context, index) {
                                  final viewer =
                                      statusController.statusViewers[index];

                                  // var contactName = await getUserNameFromMobile(
                                  //     viewer['mobile'].toString());

                                  // var name = viewer['first_name'] +
                                  //     ' ' +
                                  //     viewer['last_name'];
                                  var name = viewer['viewerName'];
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 194, 194, 194)))),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${dotenv.env['SERVER_MEDIA_URI']}${viewer['profile_pic']}'),
                                          radius: 25,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                  )
                : Container())),
      ),
    );
  }
}
