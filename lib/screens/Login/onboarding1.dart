import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'onboarding.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key, required this.onPress}) : super(key: key);
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      assetUrl: "assets/images/girl_onboarding.jpg",
      child: Column(
        children: [
          //Indicator Widget
          // const Indicators(
          //   activeIndex: 0,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Text(
              "Find Your Musical Soulmate",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Center(
            child: Text(
              "Music draws the rhythm in our lives. Meevy is there to find people with the same wavelength as us.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.grey,
                    height: 1.5,
                  ),
            ),
          ),
          InkWell(
            onTap: () {
              // onTap();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultMargin * 3),
                child: InkWell(
                  onTap: onPress,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Icon(
                        Icons.login,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
