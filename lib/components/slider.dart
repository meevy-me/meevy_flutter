import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/profile_model.dart';

class SlideToLike extends StatefulWidget {
  const SlideToLike({Key? key, required this.match, required this.onLiked})
      : super(key: key);
  final Profile match;
  final Function(Profile match) onLiked;
  @override
  State<SlideToLike> createState() => _SlideToLikeState();
}

class _SlideToLikeState extends State<SlideToLike>
    with SingleTickerProviderStateMixin {
  bool liked = false;
  bool animate = false;
  ActionSliderController controller = ActionSliderController();
  late AnimationController animationController;
  Animation? _colorAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _colorAnimation = ColorTween(begin: Colors.white, end: primaryPink)
        .animate(animationController);

    // animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var match = widget.match;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) => ActionSlider.standard(
        stateChangeCallback: (oldState, state, controller) {
          if (state.slidingState.index == 0) {
            animationController.forward();
          } else {
            animationController.reset();
          }
        },
        controller: controller,
        customOuterBackgroundBuilder: (context, state, widget) {
          return DecoratedBox(
              // position: DecorationPosition.foreground,
              decoration: BoxDecoration(color: Colors.black));
        },
        icon: Icon(
          FontAwesomeIcons.heartCirclePlus,
          color: Colors.white,
        ),
        backgroundBorderRadius: BorderRadius.circular(20),
        customForegroundBuilderChild: Container(
          padding: const EdgeInsets.all(defaultMargin),
          width: 6,
          height: 6,
          color: Colors.black,
        ),
        customBackgroundBuilder: (context, state, widget) {
          return Container(
            width: 300 * state.position,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, _colorAnimation!.value])),
          );
        },
        // backgroundColor: _colorAnimation!.value,
      ),
    );
  }
}
