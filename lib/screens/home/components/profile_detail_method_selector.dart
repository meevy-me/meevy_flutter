import 'package:flutter/material.dart';
import 'package:soul_date/animations/slide_animation.dart';

import '../../../components/spotify_card.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ProfileMatchMethod extends StatefulWidget {
  const ProfileMatchMethod({
    Key? key,
    required this.match,
  }) : super(key: key);
  final Match match;

  @override
  State<ProfileMatchMethod> createState() => _ProfileMatchMethodState();
}

class _ProfileMatchMethodState extends State<ProfileMatchMethod> {
  String selectedMethod = 'All';

  late List<Details> matches;

  @override
  void initState() {
    matches = widget.match.allItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.match.matches.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return MatchMethodSelector(
                    text: 'All',
                    active: selectedMethod == 'All',
                    onSelect: (value) {
                      setState(() {
                        selectedMethod = value;
                        matches = widget.match.allItems;
                      });
                    },
                  );
                } else {
                  MatchElement matchElement = widget.match.matches[index - 1];
                  return MatchMethodSelector(
                    text: matchElement.method,
                    active: selectedMethod == matchElement.method,
                    onSelect: (value) {
                      setState(() {
                        selectedMethod = matchElement.method;
                        matches = widget.match.matches
                            .where((element) =>
                                element.method == matchElement.method)
                            .expand((element) => element.matches)
                            .toList();
                      });
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: SlideAnimation(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: matches.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: defaultMargin),
                    child: SlideAnimation(
                      begin: const Offset(0, 250),
                      child: SpotifyCard(
                        details: matches[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatchMethodSelector extends StatelessWidget {
  const MatchMethodSelector({
    Key? key,
    required this.text,
    this.active = false,
    this.onSelect,
    this.margin,
  }) : super(key: key);
  final String text;
  final void Function(String value)? onSelect;
  final bool active;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onSelect != null) {
          onSelect!(text);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          margin: margin,
          constraints: const BoxConstraints(minWidth: 60),
          padding: const EdgeInsets.symmetric(
              horizontal: defaultMargin, vertical: defaultPadding + 2),
          decoration: BoxDecoration(
              color: active
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: active
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary,
                fontSize: 11),
          ))),
    );
  }
}
