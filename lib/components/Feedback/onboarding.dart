import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soul_date/components/icon_container.dart';

import '../../constants/constants.dart';

class FeedbackOnboarding extends StatelessWidget {
  const FeedbackOnboarding({Key? key, required this.onNext}) : super(key: key);
  final Function onNext;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
          height: size.height,
          child: SafeArea(
            child: Padding(
              padding: scaffoldPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconContainer(
                        size: 40,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          size: 30,
                        ),
                        color: Colors.grey.withOpacity(0.4),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultMargin),
                      child: Image.asset(
                        'assets/images/teamwork.png',
                        width: 300,
                        height: size.height * 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultMargin * 2,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Get A Chance To Try Out ",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                wordSpacing: 2,
                                height: 2,
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    TextSpan(
                        text: "Souldate Pro  ",
                        style: GoogleFonts.poppins(
                            wordSpacing: 2,
                            height: 2,
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold))),
                    TextSpan(
                        text: "For Free.",
                        style: GoogleFonts.poppins(
                            wordSpacing: 2,
                            textStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                  ])),
                  Text(
                    "Give us your feedback and suggestions on our services. You will be promoted to the souldate pro trial upon completion!",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(height: 2, fontSize: 14),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultMargin),
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding / 1.5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2)),
                        child: IconContainer(
                            onPress: () {
                              onNext();
                            },
                            size: 50,
                            icon: const Icon(
                              Icons.arrow_right_alt_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
