import 'package:sparrow/common/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class SettingWidget extends StatelessWidget {
  final String svg;
  final String title;
  final String num;
  final String text;
  final VoidCallback onTap;

  const SettingWidget(
      {super.key,
      required this.svg,
      required this.title,
      this.num = "",
      this.text = "",
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 47,
        child: Padding(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                ],
              ),
              Row(
                children: [
                  Text(
                    num,
                    style: const TextStyle(color: AppColors.titleColorLite),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.titleColorLite,
                    size: 16,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingWidget2 extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onTap;

  final String note;
  const SettingWidget2(
      {super.key,
      required this.title,
      this.note = "",
      this.subtitle = "",
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 47,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (subtitle != '')
                    Text(
                      subtitle,
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              Row(
                children: [
                  Text(
                    note,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingWidgetWithButton extends StatefulWidget {
  const SettingWidgetWithButton({super.key, required this.title});
  final String title;

  @override
  State<SettingWidgetWithButton> createState() =>
      _SettingWidgetWithButtonState();
}

class _SettingWidgetWithButtonState extends State<SettingWidgetWithButton> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => debugPrint("Print"),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 47,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch(
                  activeColor: Colors.green,
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NormalTextSetting extends StatelessWidget {
  final String title;
  final Color color;
  final void Function()? onTap;

  const NormalTextSetting(
      {super.key, required this.title, this.color = Colors.red, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 47,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
