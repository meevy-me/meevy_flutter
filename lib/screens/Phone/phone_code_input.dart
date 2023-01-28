import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/friends/friends_import.dart';
import 'package:soul_date/screens/home.dart';

class PhoneCodeScreen extends StatefulWidget {
  const PhoneCodeScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  State<PhoneCodeScreen> createState() => _PhoneCodeScreenState();
}

class _PhoneCodeScreenState extends State<PhoneCodeScreen> {
  String? verificationId;
  int? resendToken;
  String? error;
  final SoulController soulController = Get.find<SoulController>();
  void verificationCompleted() {
    FirebaseAuth.instance.currentUser!.linkWithPhoneNumber(widget.phoneNumber);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FriendsImportPage(),
        ));
  }

  void verificationFailed(e) {}

  @override
  void initState() {
    FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (cred) {
          verificationCompleted();
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            setState(() {
              error = "Provided phone number is not valid";
            });
          }
        },
        codeSent: (_verificationId, _resendToken) {
          verificationId = _verificationId;
          resendToken = _resendToken;
        },
        codeAutoRetrievalTimeout: (verificationID) {});
    super.initState();
  }

  TextEditingController pinInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text(
          "Verify Phone",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: scaffoldPadding,
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Code sent to the number: ${widget.phoneNumber}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18),
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Text(
                    error!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.red),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultMargin * 2),
                child: Pinput(
                  length: 6,
                  controller: pinInput,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive your code?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      if (resendToken != null) {}
                    },
                    child: Text(
                      " Resend Code",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 16),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultMargin * 2),
                child: PrimaryButton(
                    onPress: () async {
                      if (verificationId != null) {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId!,
                                smsCode: pinInput.text);
                        try {} catch (e) {
                        } finally {
                          bool res = await soulController.linkPhoneNumber();
                          if (res) {
                            Get.offAll(() => const HomePage(
                                  initialIndex: 0,
                                ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("An error has occcured")));
                          }
                        }
                      }
                    },
                    text: "Verify Phone Number"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
