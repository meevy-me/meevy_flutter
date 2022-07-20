import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/loading.dart';
import 'package:soul_date/constants/colors.dart';
import 'package:soul_date/constants/spacings.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/models/spotifyuser.dart';
import 'package:soul_date/screens/password.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: _LoginScreenBody()));
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody({Key? key}) : super(key: key);

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final SpotifyController spotifyController = Get.put(SpotifyController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      padding: scrollPadding,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Image.asset('assets/images/login hero.png',
              height: size.height * 0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: Column(
            children: [
              Text("Find & Connect",
                  style: Theme.of(context).textTheme.headline2),
              Center(
                child: Text(
                    "Find your musical soulmate or a friend that you share the same taste.Connect to your Spotify account",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          height: 2.0,
                        )),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: Loading(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: ElevatedButton(
              onPressed: () async {
                await spotifyController.spotifyLogin();
                SpotifyUser? user = spotifyController.spotify.currentUser;
                bool registered = await spotifyController.isRegistered();
                if (user!.isValid) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("SUCCESS")));

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PasswordScreen(
                          user: user, registered: !registered);
                    },
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("An error has occured, try again")));
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 2.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.spotify,
                      color: spotifyGreen,
                    ),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text(
                      "Connect To Spotify",
                      style: TextStyle(),
                    )
                  ],
                ),
              )),
        )
      ],
    );
  }
}
