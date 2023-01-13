import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sparrow/common/global_variables.dart';

class SettingWidget extends StatelessWidget {
  final String svg;
  final String title;
  final String num;
  final String text;

  const SettingWidget(
      {super.key,
      required this.svg,
      required this.title,
      required this.num,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(svg),
              const SizedBox(
                width: 10,
              ),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
            ],
          ),
          Row(
            children: [
              Text(
                num,
                style: TextStyle(color: AppColors.titleColorLite),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.titleColorLite,
                size: 16,
              )
            ],
          )
        ],
      ),
    );
  }
}
