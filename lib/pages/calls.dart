import 'package:sparrow/components/call_widget.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../common/global_variables.dart';
import '../controllers/chatsController.dart';

class CallsScreen extends StatefulWidget {
  static const routeName = 'calls';
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final callsController = Get.put((CallsController()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset("assets/icons/add_call.svg"),
                const Text(
                  "Clear All Logs",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 64, 64, 64)),
                ),
                const Icon(Icons.search)
              ],
            ),
          ),
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
                      return ListView.builder(
                        itemCount: callsController.calls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CallWidget(
                            avatar: callsController.calls[index]["avatar"],
                            name: callsController.calls[index]["name"],
                            call: callsController.calls[index]["call"],
                            callStatus: callsController.calls[index]
                                ["callStatus"],
                          );
                        },
                      );

                    default:
                      return const Text('Problem While Featching Calls');
                  }
                })),
          )
        ],
      ),
    );
  }
}
