import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/call_widget.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/controllers/userController.dart';

class CallsScreen extends StatefulWidget {
  static const routeName = 'calls';
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final callsController = Get.put((CallsController()));
  final userController = Get.put((UserController()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: callsController.getCalls(),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.done:
                      return Obx(() => callsController.calls.isNotEmpty
                          ? ListView.builder(
                              itemCount: callsController.calls.length,
                              itemBuilder: (BuildContext context, int index) {
                                final log = callsController.calls[index];
                                return CallWidget(
                                  id: log["id"].toString(),
                                  avatar: log["avatar"],
                                  name: log["name"],
                                  time: DateTime.parse(log['created_at']),
                                  callStatus: log['created_by'] ==
                                          userController.user['id']
                                      ? 'outgoing'
                                      : 'incoming',
                                );
                              },
                            )
                          : const Center(child: Text('No Call Logs Found!')));

                    default:
                      return const Center(
                          child: Text('Problem While Featching Calls'));
                  }
                })),
          )
        ],
      ),
    );
  }
}
