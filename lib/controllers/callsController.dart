import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/state_manager.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:sparrow/services/call-service.dart';
import 'package:sparrow/utils/cache-manager.dart';
import 'package:sparrow/utils/error-handlers.dart';
import 'package:sparrow/utils/user-contacts.dart';

class CallsController extends GetxController {
  var calls = [].obs;
  var usersFromContact = [].obs;
  var userSearchResults = [].obs;
  var selectedGroupContacts = [].obs;
  getCalls() async {
    final fetchedCallLogs = await CallServices().fetchCallLogs();

    for (Map log in fetchedCallLogs) {
      String name = '';

      if (log['conversation'] != null) {
        name = await getUserNameFromMobile(log['conversation'].toString());
      } else {
        name = log['group'];
      }
      log.addEntries({'name': name}.entries);
    }

    calls.value = fetchedCallLogs;
  }

  Future getUsersFromContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        List<dynamic> contactNumbers = [];
        CacheStorage().removeContacts();
        List<dynamic>? contacts = await CacheStorage().getContacts();

        contacts ??= await getSaveContacts();

        for (var contact in contacts!) {
          try {
            if (contact['phones'].length > 0) {
              var mobile =
                  formatNumber(contact['phones'][0]['number'].toString());
              contactNumbers.add(mobile);
            }
          } catch (e) {
            print(e);
          }
        }

        List<dynamic> availableUsers = await CallServices()
            .featchAvailableUsersFromContacts(contactNumbers);

        List<dynamic> usersFromContacts = availableUsers.map((avUser) {
          Map<String, dynamic>? matchedMobile = contacts!.firstWhere(
            (contact) {
              try {
                var formatedNum = '';
                if (contact['phones'].length > 0) {
                  formatedNum =
                      formatNumber(contact['phones'][0]['number'].toString());
                }

                return formatedNum == avUser['mobile'].toString();
              } catch (e) {
                return false;
              }
            },
            orElse: () => null,
          );

          Map<String, dynamic>? unMatchedMobile = contacts.firstWhere(
            (contact) {
              try {
                var formatedNum = '';
                if (contact['phones'][0]['number'] != null) {
                  formatedNum =
                      formatNumber(contact['phones'][0]['number'].toString());
                }

                return formatedNum != avUser['mobile'].toString();
              } catch (e) {
                return false;
              }
            },
            orElse: () => null,
          );

          // ignore: unnecessary_null_comparison
          if (matchedMobile != null) {
            return {
              'conv_name': matchedMobile['displayName'],
              'mobile': avUser['mobile'].toString(),
              'exists': avUser['exists'],
              'bio': avUser['bio'],
              'profile_pic': avUser['profile_pic']
            };
          } else {
            return {
              'conv_name': unMatchedMobile!['displayName'],
              'exists': avUser['exists'],
              'mobile': unMatchedMobile['mobile'],
              'bio': '',
              'profile_pic': ''
            };
          }
        }).toList();

        print(usersFromContacts);

        usersFromContact.value = usersFromContacts;
      }
    } catch (e) {
      print(e);
      toasterUnknownFailure();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
