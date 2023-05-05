import 'package:sparrow/common/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sparrow/components/contactChat.dart';
import 'package:sparrow/components/customButton.dart';
import 'package:sparrow/controllers/callsController.dart';
import 'package:sparrow/controllers/chatsController.dart';
import 'package:sparrow/controllers/userController.dart';
import 'package:sparrow/pages/conversation/chatRoom.dart';
import 'package:sparrow/pages/conversation/groupChatRoom.dart';
import 'package:sparrow/utils/error-handlers.dart';

class ContactUsers extends StatefulWidget {
  static const routeName = 'contact-users';
  const ContactUsers({super.key});

  @override
  State<ContactUsers> createState() => _ContactUsersState();
}

class _ContactUsersState extends State<ContactUsers> {
  final chatsController = Get.put(ChatsController());
  final callsController = Get.put(CallsController());
  final userController = Get.put(UserController());
  TextEditingController searchContactsController = TextEditingController();
  List searchResults = [];

  bool isCreatingGroup = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    callsController.getUsersFromContacts().then(
      (_) {
        searchResults.addAll(callsController.usersFromContact.value);
        setState(() {});
      },
    );

    super.initState();
  }

  @override
  Future<void> dispose() async {
    callsController.selectedGroupContacts.clear();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var usersFromContacts = callsController.usersFromContact.value;
    void onSearchFromContact(String query) {
      searchResults.clear();
      if (query == '') {
        searchResults.addAll(callsController.usersFromContact.value);
        setState(() {});
        return;
      }

      for (var contactUser in usersFromContacts) {
        if (contactUser['conv_name']
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchResults.add(contactUser);
        }
      }

      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xfff2f2f2),
        centerTitle: true,
        title: const Text('Contacts',
            style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: AppColors.titleColor)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appBarColor,
          ),
        ),
      ),
      floatingActionButton: isCreatingGroup
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'cancel-creating-grp',
                  onPressed: () {
                    callsController.selectedGroupContacts.value = [];
                    setState(() {
                      isCreatingGroup = false;
                    });
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'done-creating-grp',
                  onPressed: () async {
                    bool isSuccess = await chatsController.onCreateGroupChat(
                        'Group (${([
                              userController.user['mobile']
                            ] + callsController.selectedGroupContacts.value).join(', ')})',
                        callsController.selectedGroupContacts.value + [userController.user['mobile']],
                        [userController.user['mobile']]);

                    if (isSuccess) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context,
                          GroupChatRoomScreen.routeName +
                              chatsController.chatRoomDetails.value['id']
                                  .toString());
                    }
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.done),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  isCreatingGroup = true;
                });
                toasterSuccessMsg('Tap on contacts you want to add');
              },
              backgroundColor: AppColors.appBarColor,
              child: const Icon(Icons.create),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: AppColors.backgroundGrayMoreLight,
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: searchContactsController,
                    decoration: const InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchFromContact,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      searchContactsController.clear();
                      onSearchFromContact('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ContactChatCardComponent(
                  contactUser: searchResults[index],
                  isCreatingGroup: isCreatingGroup,
                  isSelected: (bool value) {
                    if (value) {
                      callsController.selectedGroupContacts
                          .add(searchResults[index]['mobile']);
                    } else {
                      callsController.selectedGroupContacts
                          .remove(searchResults[index]['mobile']);
                    }
                    print("$index : $value");
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
