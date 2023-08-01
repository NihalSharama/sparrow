import 'package:flutter/material.dart';
import 'package:sparrow/common/global_variables.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  static const routeName = '/explore';

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Explore',
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
        child: Text('Feature Comming Soon...'),
      ),
    );
  }
}
