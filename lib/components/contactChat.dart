import 'package:get/get.dart';
import 'package:sparrow/common/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';

class ContactChatCardComponent extends StatefulWidget {
  final ValueChanged<bool> isSelected;
  final bool isCreatingGroup;
  final Map contactUser;
  // msgStatus: sent, received, seen

  const ContactChatCardComponent({
    super.key,
    required this.isSelected,
    required this.contactUser,
    required this.isCreatingGroup,
  });

  @override
  State<ContactChatCardComponent> createState() =>
      _ContactChatCardComponentState();
}

class _ContactChatCardComponentState extends State<ContactChatCardComponent> {
  final callsController = Get.put(CallsController());
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    isSelected = callsController.selectedGroupContacts
        .contains(widget.contactUser['mobile']);
    return InkWell(
      onTap: () {
        if (widget.isCreatingGroup) {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
          setState(() {});
        } else {
          if (!widget.contactUser['exists']) {
            return;
          } else {
            Navigator.pushReplacementNamed(context,
                '${ChatRoomScreen.routeName}${widget.contactUser['mobile'].toString()}');
          }
        }
      },
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          child: Container(
              height: 85,
              width: double.infinity,
              // ignore: sort_child_properties_last
              child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.contactUser['exists']) ...{
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              '${dotenv.env['SERVER_MEDIA_URI']}${widget.contactUser['profile_pic']}'),
                        )
                      } else
                        const CircleAvatar(
                          minRadius: 30,
                          maxRadius: 30,
                          backgroundImage:
                              AssetImage('assets/images/default2.jpg'),
                        ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.contactUser['conv_name'] ?? ' ',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 61, 61, 61)),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                  (widget.contactUser['exists']
                                      ? widget.contactUser['bio']
                                      : 'Not on client :('),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.descriptionColorLight,
                                  ))
                            ]),
                      ),
                      isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.keyboard_arrow_right)
                    ],
                  )),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 211, 211, 211)))))),
    );
  }
}
