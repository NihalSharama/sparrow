import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sparrow/common/global_variables.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color color;
  final Color textcolor;
  final double elevation;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = 0,
    this.height = 0,
    this.color = AppColors.appBarColor,
    this.textcolor = Colors.white,
    this.elevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          primary: color,
          minimumSize: ((width == 0 && height == 0)
              ? const Size(double.infinity, 50)
              : Size(width, height)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
            fontSize: 16,
          ),
        ));
  }
}

class CustomButtonBordered extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color color;
  const CustomButtonBordered(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.width = 0,
      this.height = 0,
      this.color = AppColors.appBarColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            textStyle: TextStyle(
              color: color,
            ),
            minimumSize: ((width == 0 && height == 0)
                ? const Size(double.infinity, 50)
                : Size(width, height)),
            side: BorderSide(color: color, width: 2)),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
        ));
  }
}
