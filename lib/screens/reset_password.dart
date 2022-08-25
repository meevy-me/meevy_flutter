import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/screens/password.dart';
import 'package:soul_date/screens/password_reset_email.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key, required this.grantType})
      : super(key: key);
  final String grantType;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();
  final SpotifyController controller = Get.find<SpotifyController>();
  String? errors;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: scrollPadding,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultMargin),
            child: Text(
              "Reset your souldate password",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          errors != null
              ? Text(
                  errors!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.red),
                )
              : const SizedBox.shrink(),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthField(
                      hintText: "Enter New Password",
                      controller: pass1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin * 2),
                      child: AuthField(
                        hintText: "Re-enter password",
                        controller: pass2,
                        validator: (value) {
                          if (value == null) {
                            return "Field is required";
                          }
                          if (pass1.text != value) {
                            return "Passwords dont match";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              )),
          PrimaryButton(
              onPress: () async {
                Map<String, String> body = {};

                body['password1'] = pass1.text;
                body['password2'] = pass2.text;

                var errors =
                    await controller.resetPassword(widget.grantType, body);
                if (errors == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PasswordScreen(
                              user: controller.spotify.currentUser!)));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(errors)));
                  Get.to(() => PasswordResetEmail(
                      user: controller.spotify.currentUser!));
                }
              },
              text: "Reset Password")
        ],
      ),
    );
  }
}
