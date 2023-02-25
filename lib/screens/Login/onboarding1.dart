import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'onboarding.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key, required this.onPress}) : super(key: key);
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Onboarding(
      assetUrl: "assets/images/girl_onboarding.jpg",
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
              "Find Your Musical Soulmate",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: Center(
              child: Text(
                "Music draws the rhythm in our lives. Meevy is there to find people with the same wavelength as us.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: ElevatedButton(
                onPressed: onPress,
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: defaultMargin,
                        ),
                        Text(
                          "Proceed to Meevy",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
