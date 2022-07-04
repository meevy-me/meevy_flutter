import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:soul_date/models/match_model.dart';

class SlideToLike extends StatefulWidget {
  const SlideToLike({Key? key, required this.match, required this.onLiked})
      : super(key: key);
  final Match match;
  final Function(Match match) onLiked;
  @override
  State<SlideToLike> createState() => _SlideToLikeState();
}

class _SlideToLikeState extends State<SlideToLike> {
  bool liked = false;
  bool animate = false;
  @override
  Widget build(BuildContext context) {
    return ConfirmationSlider(
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(6.0, 6.0),
          blurRadius: 16.0,
        ),
        foregroundColor: Colors.transparent,
        width: 300,
        height: 60,
        text: "Slide to Like ${widget.match.matched.name}",
        textStyle: Theme.of(context).textTheme.caption,
        onConfirmation: () {
          Future.delayed(const Duration(microseconds: 100), () {
            setState(() {
              liked = true;

              widget.onLiked(widget.match);
            });
          });
        },
        stickToEnd: true,
        onTapDown: () {
          setState(() {
            animate = true;
          });
        },
        onTapUp: () {
          setState(() {
            animate = false;
          });
        },
        sliderButtonContent: Icon(
          FontAwesomeIcons.heartCirclePlus,
          color: Theme.of(context).primaryColor,
        ));
  }
}
