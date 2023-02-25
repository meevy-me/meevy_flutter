import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/constants.dart';
import 'onboarding.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key, this.onPress, this.onBack}) : super(key: key);
  final Function()? onPress;
  final Function()? onBack;
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      assetUrl: "assets/images/man_onboarding.jpg",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Indicator Widget
          // const Indicators(
          //   activeIndex: 0,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Text(
              "Connect Your Spotify Account",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: Center(
              child: Text(
                "Link your Spotify account to enjoy Meevy. By proceeding you agree to the Terms & Conditions and Privacy Policy.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: ElevatedButton(
                onPressed: onPress,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: defaultPadding * 2.2),
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
          ),

          InkWell(
            onTap: onBack,
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                Text(
                  "Go Back",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
