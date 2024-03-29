import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FormFieldValidator validator;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final Color fillColor;
  final Color textColor;
  final double paddingTop;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.validator,
    required this.hintText,
    this.maxLines = 1,
    this.fillColor = const Color.fromARGB(255, 237, 237, 237),
    this.textColor = const Color.fromARGB(255, 165, 165, 165),
    this.paddingTop = 8,
    required this.keyboardType,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: TextFormField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
          contentPadding:
              EdgeInsets.only(left: 20.0, bottom: 8.0, top: paddingTop),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
