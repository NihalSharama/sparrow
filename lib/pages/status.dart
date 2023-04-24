import 'package:sparrow/components/pop-ups/createStatusPopup.dart';
import 'package:sparrow/controllers/statusController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/components/status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as path;
import 'package:sdp_transform/sdp_transform.dart';

class StatusScreen extends StatefulWidget {
  static const routeName = 'status';
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final statusController = Get.put(StatusController());
    final userController = Get.put(UserController());

    return FutureBuilder(
      future: statusController.getStatus(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case ConnectionState.done:
            return Obx(
              () => Container(
                color: const Color(0xfff2f2f2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      if (statusController
                                          .myStatus.value.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StatusView(
                                                      stories: statusController
                                                          .myStatus.value,
                                                    )));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const CreateStatusPopup();
                                          },
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const CreateStatusPopup();
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: (statusController.myStatus.isEmpty
                                          ? 25
                                          : 30),
                                      backgroundColor:
                                          Color.fromARGB(255, 183, 64, 230),
                                      child: (statusController.myStatus.isEmpty
                                          ? CircleAvatar(
                                              // backgroundColor: Colors.amber,
                                              backgroundImage: NetworkImage(
                                                  '${dotenv.env['SERVER_MEDIA_URI']}${userController.user['profile_pic']}'),
                                              radius: 25,
                                            )
                                          : (path
                                                  .extension(statusController
                                                      .myStatus[statusController
                                                          .myStatus.length -
                                                      1]['media'])
                                                  .isImageFileName
                                              ? CircleAvatar(
                                                  // backgroundColor: Colors.amber,
                                                  backgroundImage: NetworkImage(
                                                      '${dotenv.env['SERVER_MEDIA_URI']}${statusController.myStatus[statusController.myStatus.length - 1]['media']}'),
                                                  radius: 25,
                                                )
                                              : const CircleAvatar(
                                                  // backgroundColor: Colors.amber,
                                                  backgroundImage: AssetImage(
                                                      "assets/icons/play-video.png"),
                                                  radius: 25,
                                                ))),
                                    )),
                                if (statusController.myStatus.isEmpty) ...{
                                  Positioned(
                                    bottom: 0.0,
                                    right: 1.0,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  )
                                }
                              ],
                            ),
                          ),
                          title: const Text(
                            "My Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(statusController.myStatus.isEmpty
                              ? "Tap or Hold to add status"
                              : DateFormat('h:mma').format(DateTime.parse(
                                  statusController.myStatus[
                                          statusController.myStatus.length - 1]
                                      ['created_at']))),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Viewed updates",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: statusController.contactStatuses.length,
                        itemBuilder: (context, index) {
                          var statusesOfContact =
                              statusController.contactStatuses[index];

                          var username = statusesOfContact.keys.toList()[0];

                          var statuses = [];

                          for (var statusOfContact
                              in statusesOfContact[username]) {
                            statuses.add(statusOfContact);
                          }
                          var timestamp = DateFormat('h:mma').format(
                              DateTime.parse(
                                  statuses[statuses.length - 1]['created_at']));

                          return Container(
                            color: const Color(0xfff2f2f2),
                            child: ListTile(
                              leading: (path
                                      .extension(statuses[statuses.length - 1]
                                          ['media'])
                                      .isImageFileName
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          "${dotenv.env['SERVER_MEDIA_URI']}${statuses[statuses.length - 1]['media']}"),
                                    )
                                  : const CircleAvatar(
                                      // backgroundColor: Colors.amber,
                                      backgroundImage: AssetImage(
                                          "assets/icons/play-video.png"),
                                      radius: 30,
                                    )),
                              title: Text(
                                username,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(timestamp),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StatusView(
                                              stories: statuses,
                                            )));
                              },
                            ),
                          );
                          ;
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          default:
            return const Scaffold(
              body: Center(
                child: Text('Something Whent Wrong'),
              ),
            );
        }
      },
    );
  }
}
