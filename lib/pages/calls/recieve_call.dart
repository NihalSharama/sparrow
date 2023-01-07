import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RecieveCall extends StatefulWidget {
  const RecieveCall({super.key});

  @override
  State<RecieveCall> createState() => _RecieveCallState();
}

class _RecieveCallState extends State<RecieveCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Call Utha bsdk'),
      ),
    );
  }
}
