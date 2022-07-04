import 'package:flutter/material.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/match_model.dart';

import 'match_image.dart';
import 'spotify_card.dart';

class MatchCard extends StatefulWidget {
  const MatchCard({Key? key, required this.match, required this.onLiked})
      : super(key: key);

  final Match match;
  final Function(Match match) onLiked;
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
            match: widget.match,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.match.details.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: defaultMargin),
                  child: SpotifyCard(
                    details: widget.match.details[index],
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
