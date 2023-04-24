import 'package:sparrow/controllers/statusController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPopup extends StatefulWidget {
  final Column elements;
  const CustomPopup({super.key, required this.elements});
  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  final statusController = Get.put(StatusController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.all(15),
        scrollable: true,
        content: widget.elements);
  }
}
