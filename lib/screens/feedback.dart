import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_date/components/Feedback/question_card.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home.dart';

import '../components/Feedback/onboarding.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final PageController pageController = PageController();
  final SoulController controller = Get.find<SoulController>();
  Duration duration = const Duration(milliseconds: 400);
  Curve curve = Curves.easeIn;
  List answers = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          FeedbackOnboarding(
            onNext: () {
              pageController.nextPage(duration: duration, curve: curve);
            },
          ),
          FeedbackQuestion1(
            onBack: () {
              pageController.previousPage(duration: duration, curve: curve);
            },
            onNext: (value) {
              answers.add(value);
              pageController.nextPage(duration: duration, curve: curve);
            },
          ),
          FeedbackQuestion2(
            onBack: () {
              pageController.previousPage(duration: duration, curve: curve);
            },
            onNext: (value) {
              answers.add(value);
              pageController.nextPage(duration: duration, curve: curve);
            },
          ),
          FeedbackQuestion3(
            onBack: () {
              pageController.previousPage(duration: duration, curve: curve);
            },
            onNext: (value) {
              answers.add(value);
              pageController.nextPage(duration: duration, curve: curve);
            },
          ),
          SafeArea(
            child: SizedBox(
              height: size.height,
              child: Padding(
                padding: scaffoldPadding,
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultMargin),
                      child: LottieBuilder.asset(
                        'assets/images/thanks.json',
                        height: 300,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Thank you for your sharing your thoughts.\nWe appreciate your feedback.",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin * 4),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Container(
                            padding: const EdgeInsets.all(defaultPadding / 1.5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            child: IconContainer(
                                onPress: () {
                                  controller.feedbackPush(answers);
                                  Get.offAll(
                                      () => HomePage(store: controller.store));
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeedbackQuestion1 extends StatefulWidget {
  const FeedbackQuestion1(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);
  final Function(dynamic value) onNext;
  final Function onBack;
  //TODO: Implement Dispose
  @override
  State<FeedbackQuestion1> createState() => _FeedbackQuestion1State();
}

class _FeedbackQuestion1State extends State<FeedbackQuestion1>
    with AutomaticKeepAliveClientMixin {
  int selectedNumber = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: Padding(
        padding: scaffoldPadding,
        child: Center(
          child: FeedbackQuestionCard(
            onBack: () {
              widget.onBack();
            },
            onNext: () {
              if (selectedNumber != 0) {
                widget.onNext({
                  'question': "How satisfied are you with the service",
                  'value': selectedNumber
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Text(
                    "How satisfied are you with the service",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 1; i < 6; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedNumber = i;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: size.width / 7,
                          padding: const EdgeInsets.all(defaultPadding),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedNumber == i
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(0.4)),
                          child: Center(
                              child: Text(
                            i.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Not satisfied",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "Very satisfied",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FeedbackQuestion2 extends StatefulWidget {
  const FeedbackQuestion2(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);
  final Function(dynamic value) onNext;
  final Function onBack;

  @override
  State<FeedbackQuestion2> createState() => _FeedbackQuestion2State();
}

class _FeedbackQuestion2State extends State<FeedbackQuestion2>
    with AutomaticKeepAliveClientMixin {
  int selectedNumber = 0;
  TextEditingController answer = TextEditingController();
  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: Padding(
        padding: scaffoldPadding,
        child: Center(
          child: FeedbackQuestionCard(
            number: 2,
            onBack: () {
              widget.onBack();
            },
            onNext: () {
              if (answer.text.isNotEmpty) {
                widget.onNext({
                  'question': "What do you want improved in the service?",
                  'value': answer.text
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Text(
                    "What do you want improved in the service?",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                AuthTextArea(
                  hintText: "Your Suggestion",
                  controller: answer,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class FeedbackQuestion3 extends StatefulWidget {
  const FeedbackQuestion3(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);
  final Function(dynamic value) onNext;
  final Function onBack;

  @override
  State<FeedbackQuestion3> createState() => _FeedbackQuestion3State();
}

class _FeedbackQuestion3State extends State<FeedbackQuestion3>
    with AutomaticKeepAliveClientMixin {
  int selectedNumber = 0;
  TextEditingController answer = TextEditingController();

  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: Padding(
        padding: scaffoldPadding,
        child: Center(
          child: FeedbackQuestionCard(
            number: 3,
            onBack: () {
              widget.onBack();
            },
            onNext: () {
              if (answer.text.isNotEmpty) {
                widget.onNext({
                  'question': "What do you want added to the service?",
                  'value': answer.text
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Text(
                    "What do you want added to the service?",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                AuthTextArea(
                  hintText: "Your Suggestion",
                  controller: answer,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
