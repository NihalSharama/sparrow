import 'package:flutter/material.dart';
import 'package:sparrow/common/global_variables.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});
  static const routeName = '/reels';

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Reels',
            style: TextStyle(color: AppColors.titleColor),
          ),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.titleColor,
              ))),
      body: const Center(
        child: Text('Feature Coming Soon...'),
      ),
    );
  }
}
