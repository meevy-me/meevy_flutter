import 'package:flutter/material.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/models.dart';

import 'match_image.dart';
import 'spotify_card.dart';

class MatchCard extends StatefulWidget {
  const MatchCard({
    Key? key,
    required this.profile,
    required this.matchElement,
  }) : super(key: key);

  final Profile profile;
  final MatchElement matchElement;
  // final Function(Match match) onLiked;
  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
      child: Column(
        children: [
          MatchImage(
              profile: widget.profile, matchElement: widget.matchElement),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: SlideAnimation(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.matchElement.matches.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: defaultMargin),
                    child: SlideAnimation(
                      begin: const Offset(0, 250),
                      child: SpotifyCard(
                        details: widget.matchElement.matches[index],
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
