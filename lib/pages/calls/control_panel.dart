import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class ControlPanel extends StatefulWidget {
  final isMute;
  final isVideo;
  final onPressMute;
  final onPressVideo;
  final onHangUp;
  const ControlPanel(
      {super.key,
      required this.isMute,
      required this.isVideo,
      required this.onPressMute,
      required this.onPressVideo,
      required this.onHangUp});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  var isSpeaker = false;
  onSpeaker() {
    setState(() {
      isSpeaker = !isSpeaker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Color.fromARGB(255, 60, 72, 249)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: SvgPicture.asset(
              (isSpeaker
                  ? 'assets/icons/speaker.svg'
                  : 'assets/icons/speaker_off.svg'),
            ),
            onPressed: onSpeaker,
          ),
          IconButton(
            icon: Icon(widget.isMute ? Icons.mic_off : Icons.mic),
            onPressed: widget.onPressMute,
          ),
          IconButton(
            icon: Icon(widget.isVideo ? Icons.videocam : Icons.videocam_off),
            onPressed: widget.onPressVideo,
          ),
          CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
                onPressed: widget.onHangUp,
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
