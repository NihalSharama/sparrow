// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectContact extends StatefulWidget {
  static const routeName = 'select_contact';

  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<Contact>? contacts;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    getContact();
    super.initState();
  }

  getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            "Contacts",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: FutureBuilder(
          future: getContact(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.done:
                return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: contacts!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Colors.blue),
                                child: Align(
                                    alignment: Alignment.center,
                                    child:
                                        Text(contacts![index].displayName[0])),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                contacts![index].displayName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              )
                            ],
                          );
                        }));

              default:
                return const Text('No Contacts Found');
            }
          },
        ));
  }
}
