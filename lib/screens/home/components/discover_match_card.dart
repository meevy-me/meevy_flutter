import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:soul_date/components/match_card.dart';
import 'package:soul_date/screens/match_detail.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/models/models.dart';
import '../../../animations/page_transition.dart';
import '../../../constants/constants.dart';
import '../../profile_detail.dart';

class DiscoverMatch extends StatefulWidget {
  const DiscoverMatch({
    Key? key,
    required this.match,
  }) : super(key: key);

  final Match match;

  @override
  State<DiscoverMatch> createState() => _DiscoverMatchState();
}

class _DiscoverMatchState extends State<DiscoverMatch>
    with AutomaticKeepAliveClientMixin<DiscoverMatch> {
  int currentIndex = 0;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // Match match = widget.matchesList[_index];

        SwipeDetector(
          onSwipeRight: (offset) {
            if (currentIndex > 0) {
              setState(() {
                currentIndex -= 1;
              });
            }
          },
          onSwipeLeft: (offset) {
            if (currentIndex < widget.match.matches.length - 1) {
              setState(() {
                currentIndex += 1;
              });
            }
          },
          child: InkWell(
            onTap: () => Navigation.push(
              context,
              screen: ProfileDetailScreen(
                  match: widget.match, profile: widget.match.profile),
            ),
            child: MatchCard(
                profile: widget.match.profile,
                matchElement: widget.match.matches[currentIndex]),
          ),
        ),

        widget.match.matches.length != 1
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < widget.match.matches.length; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: const Duration(
                          milliseconds: 950,
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        height: 15,
                        width: currentIndex == i ? 30 : 15,
                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(20),
                            color: currentIndex == i
                                ? Theme.of(context).primaryColor
                                : Colors.grey)),
                  )
              ])
            : const SizedBox.shrink()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
