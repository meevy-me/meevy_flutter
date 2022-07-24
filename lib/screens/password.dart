import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/models/spotifyuser.dart';
import 'package:soul_date/screens/password_reset_email.dart';

class PasswordScreen extends StatelessWidget {
  final SpotifyUser user;
  const PasswordScreen({Key? key, required this.user, this.registered = false})
      : super(key: key);
  final bool registered;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: buildAppBar(context),
          body: _PasswordScreenBody(
            registered: registered,
            user: user,
          )),
    );
  }
}

class _PasswordScreenBody extends StatefulWidget {
  final SpotifyUser user;
  final bool registered;
  const _PasswordScreenBody(
      {Key? key, required this.user, required this.registered})
      : super(key: key);

  @override
  State<_PasswordScreenBody> createState() => _PasswordScreenBodyState();
}

class _PasswordScreenBodyState extends State<_PasswordScreenBody> {
  final TextEditingController email = TextEditingController();

  final TextEditingController pass1 = TextEditingController();

  final TextEditingController pass2 = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SpotifyController spotifyController = Get.find<SpotifyController>();
  @override
  void initState() {
    spotifyController.errors = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: scaffoldPadding,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Column(
            children: [
              ClipOval(
                  child: CachedNetworkImage(
                imageUrl: widget.user.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(
                "Hello ${widget.user.displayName}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
        GetBuilder<SpotifyController>(
            id: "Login_errors",
            builder: (controller) {
              return Text(
                controller.errors,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red),
              );
            }),
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: widget.registered
                ? _RegisterWidget(
                    pass1: pass1,
                    pass2: pass2,
                    email: email,
                  )
                : _LoginWidget(
                    user: widget.user,
                    pass: pass1,
                  ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: PrimaryButton(
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    late Map<String, String> body;
                    if (widget.registered) {
                      body = {
                        'email': email.text,
                        'password1': pass1.text,
                        'password2': pass2.text
                      };
                    } else {
                      body = {'password': pass1.text};
                    }
                    spotifyController.authenticate(body);
                  }
                },
                text: widget.registered ? "Register" : "Login",
                icon: const Icon(Icons.login)))
      ],
    );
  }
}

class _RegisterWidget extends StatelessWidget {
  const _RegisterWidget(
      {Key? key, required this.email, required this.pass1, required this.pass2})
      : super(key: key);
  final TextEditingController email;
  final TextEditingController pass1;
  final TextEditingController pass2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create souldate account to continue",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: AuthField(
            controller: email,
            hintText: "Enter Email Address",
            validator: (String? value) {
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: AuthField(
            controller: pass1,
            hintText: "Enter Password",
            obscureText: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: AuthField(
            controller: pass2,
            hintText: "Confirm Password",
            obscureText: true,
            validator: (String? value) {
              if (pass1.text != value) {
                return "Passwords don't match";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({
    Key? key,
    required this.pass,
    required this.user,
  }) : super(key: key);
  final TextEditingController pass;
  final SpotifyUser user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter your souldate password to continue",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: AuthField(
            hintText: "Enter Password",
            obscureText: true,
            controller: pass,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin / 2),
          child: Row(
            children: [
              Text(
                "Forgot Password?",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              InkWell(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetEmail(
                                user: user,
                              )));
                }),
                child: Text(
                  " Reset Password?",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
