import 'package:flutter/material.dart';
import 'package:soul_date/components/blurred_image.dart';
import 'package:soul_date/constants/constants.dart';

class MusicMapScreen extends StatelessWidget {
  const MusicMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlurredImage(
              imagePath: 'assets/images/map.png',
              height: size.height,
              width: size.width),
          Positioned(
            bottom: 0,
            top: defaultMargin * 4,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "COMING SOON! MeevyMap",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    "Have a glimpse of what people near you are listening to",
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
