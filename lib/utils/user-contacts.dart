import 'dart:convert';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sparrow/utils/cache-manager.dart';

formatNumber(String mobile) {
  var formatedmobile = mobile.replaceAll(RegExp(r'[^\w\s]+'), '' '');
  formatedmobile = formatedmobile.replaceAll(RegExp(r"\s\b|\b\s"), '');
  formatedmobile = formatedmobile.replaceAll(RegExp(r"91"), ''); // remove 91
  formatedmobile = formatedmobile.replaceAll(RegExp(r"/\+/g"), ''); // remove +

  return formatedmobile;
}

getSaveContacts() async {
  List<Contact> contacts = [];
  if (await FlutterContacts.requestPermission()) {
    contacts = await FlutterContacts.getContacts(
        withProperties: true, withPhoto: false);
  }

  CacheStorage().saveContacts(contacts);

  var contactsJson = jsonEncode(contacts);

  return json.decode(contactsJson);
}

Future<String> getUserNameFromMobile(String mobile) async {
  var contacts = await CacheStorage().getContacts();
  contacts ??= await getSaveContacts();

  String username = mobile.toString();
  contacts.forEach((contact) {
    if (contact['phones'].length == 0) {
      print(contact['displayName'] + ':  ' + contact['phones'].toString());
    }
    if (contact['phones'].length > 0) {
      if (formatNumber(contact['phones'][0]['number'].toString()) == mobile) {
        username = contact['displayName'];
      }
    }
  });

  return username;
}
