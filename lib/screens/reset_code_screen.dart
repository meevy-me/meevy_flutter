import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/screens/reset_password.dart';

class ResetCodeScreen extends StatefulWidget {
  const ResetCodeScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<ResetCodeScreen> createState() => _ResetCodeScreenState();
}

class _ResetCodeScreenState extends State<ResetCodeScreen> {
  final TextEditingController code = TextEditingController();
  final SpotifyController spotifyController = Get.find<SpotifyController>();
  String? error = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultMargin, vertical: defaultMargin * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter 7 Digit Code",
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  error != null
                      ? Text(
                          error!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.red),
                        )
                      : const SizedBox.shrink(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: Pinput(
                      length: 7,
                      validator: (value) {
                        return error;
                      },
                      onChanged: (value) {
                        setState(() {
                          error = null;
                        });
                      },
                      onCompleted: (value) async {
                        setState(() {
                          error = null;
                        });
                        var result =
                            await spotifyController.validatResetCode(value);
                        if (result != "error") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ResetPasswordScreen(grantType: result)));
                        } else {
                          setState(() {
                            error = "Code is incorrect or expired";
                          });
                        }
                      },
                      defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: Theme.of(context).textTheme.bodyText1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin / 2),
              child: Row(
                children: [
                  Text(
                    "Having Problems?",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  InkWell(
                    onTap: (() {
                      spotifyController
                          .resetPasswordEmail({'email': widget.email});
                    }),
                    child: Text(
                      " Resend email",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
