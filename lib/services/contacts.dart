import 'dart:convert';
import 'dart:developer';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/network.dart';
import 'package:http/http.dart';

Future<List<Phone>> getContacts() async {
  await FlutterContacts.requestPermission();
  List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
  List<Phone> phones = [];
  for (Contact contact in contacts) {
    phones.addAll(contact.phones);
  }
  // print(phones.length);
  return phones;
}

Future<List<String>> getPhoneNumbers() async {
  var phoneNumbers = await getContacts();
  List<String> numbers = [];
  await FlutterLibphonenumber().init();
  for (var phone in phoneNumbers) {
    var numberFormat = phone.number.replaceAll(" ", "").replaceAll("-", "");
    try {
      var number = await FlutterLibphonenumber().parse(numberFormat);
      numbers.add(number['e164']);
    } catch (e) {}
  }
  return numbers;
}

Future<List<Profile>> getContactProfiles() async {
  HttpClient client = HttpClient();
  var numbers = await getPhoneNumbers();

  var data = {"phone_numbers": numbers};
  Response res = await client.post(phoneNumberSearchUrl,
      body: {},
      bodyRaw: jsonEncode(data),
      headersAdd: {"Content-Type": 'application/json'});
  if (res.statusCode <= 210) {
    return profileFromJson(utf8.decode(res.bodyBytes));
  } else if (res.statusCode <= 403) {}
  return [];
}
