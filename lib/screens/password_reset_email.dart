import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/models/spotifyuser.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class PasswordResetEmail extends StatefulWidget {
  final SpotifyUser user;

  const PasswordResetEmail({Key? key, required this.user}) : super(key: key);

  @override
  State<PasswordResetEmail> createState() => _PasswordResetEmailState();
}

class _PasswordResetEmailState extends State<PasswordResetEmail> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SpotifyController spotifyController = Get.find<SpotifyController>();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: scrollPadding,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Row(
              children: [
                Text(
                  "Hello ${widget.user.displayName}",
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: widget.user.image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ))
              ],
            ),
          ),
          Text(
            "A seven digit code will be sent to your email in order to reset password",
            style: Theme.of(context).textTheme.caption,
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultMargin * 2),
            child: Text(
              "Enter your souldate email",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: AuthField(
                hintText: "Enter your email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "* This field is required";
                  }
                  if (!value.isValidEmail()) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: PrimaryButton(
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, String> body = {};
                    body['email'] = emailController.text;
                    spotifyController.resetPasswordEmail(body);
                  }
                },
                text: "Send Email"),
          )
        ],
      ),
    );
  }
}
