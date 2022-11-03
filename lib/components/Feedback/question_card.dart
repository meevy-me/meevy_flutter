import 'package:flutter/material.dart';
import 'package:soul_date/components/buttons.dart';

import '../../constants/constants.dart';

class FeedbackQuestionCard extends StatelessWidget {
  const FeedbackQuestionCard({
    Key? key,
    required this.child,
    this.number = 1,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);
  final Widget child;
  final int number;
  final Function onNext;
  final Function onBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: double.infinity, minHeight: 250),
      padding: const EdgeInsets.all(defaultMargin),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question $number",
                style: Theme.of(context).textTheme.headline5,
              ),
              Container(
                  padding: const EdgeInsets.all(defaultPadding / 3),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2), shape: BoxShape.circle),
                  child: const Icon(
                    Icons.question_mark,
                    size: 15,
                  ))
            ],
          ),
          child,
          const SizedBox(
            height: defaultMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  onBack();
                },
                child: Text("Back",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 17)),
              ),
              PrimaryButton(
                onPress: () {
                  onNext();
                },
                text: "Next",
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              )
            ],
          )
        ],
      ),
    );
  }
}
