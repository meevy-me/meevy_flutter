import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:soul_date/screens/Phone/phone_code_input.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  //TODO: Change later to get find
  final SoulController soulController = Get.find<SoulController>();
  PhoneNumber initialNumber = PhoneNumber();
  PhoneNumber usersPhoneNumber = PhoneNumber();
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  void initState() {
    getCountryCode();
    super.initState();
  }

  void getCountryCode() async {
    String? countryCode = await FlutterSimCountryCode.simCountryCode;
    setState(() {
      initialNumber = PhoneNumber(isoCode: countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: scaffoldPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Your Mobile Number",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: defaultMargin / 2,
              ),
              Text(
                "We'll text you a verification code. Message and data rates may apply",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultMargin * 2),
                child: PhoneAuthField(
                  textEditingController: phoneNumberController,
                  initialValue: initialNumber,
                  onInputChanged: (value) {
                    usersPhoneNumber = value;
                  },
                  hintText: "Enter Phone Number",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: PrimaryButton(
                    onPress: () {
                      if (usersPhoneNumber.phoneNumber != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneCodeScreen(
                                phoneNumber: usersPhoneNumber.phoneNumber!,
                              ),
                            ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "Enter a valid phone number",
                          style: TextStyle(color: Colors.red),
                        )));
                      }
                    },
                    text: "Send Verification Code"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
