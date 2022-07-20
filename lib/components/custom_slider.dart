import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_date/constants/constants.dart';

class SoulSlider extends StatefulWidget {
  const SoulSlider(
      {Key? key,
      this.width,
      this.height,
      this.padding,
      required this.onComplete,
      required this.defaultText,
      required this.completedWidget})
      : super(key: key);
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Function onComplete;
  final String defaultText;
  final Widget completedWidget;

  @override
  State<SoulSlider> createState() => _SoulSliderState();
}

class _SoulSliderState extends State<SoulSlider>
    with SingleTickerProviderStateMixin {
  Offset horizontalPosition = const Offset(defaultPadding, 0);
  bool slideComplete = false;
  late AnimationController _animationController;
  Tween<double> opacity = Tween(begin: 0, end: 1);
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double widgetWidth = widget.width ?? size.width;

    return slideComplete
        ? widget.completedWidget
        : SizedBox(
            width: widget.width ?? size.width,
            child: Stack(
              children: [
                Container(
                  height: 60,
                  width: widgetWidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(6.0, 6.0),
                          blurRadius: 16.0,
                        ),
                      ]),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: widget.height ?? 60,
                  child: Center(
                    child: Text(widget.defaultText,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color:
                                1 * (horizontalPosition.dx / widgetWidth) > 0.5
                                    ? Colors.white
                                    : Colors.black)),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(1 * (horizontalPosition.dx / widgetWidth)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: horizontalPosition.dx,
                  // right: 0,
                  child: GestureDetector(
                    // onHorizontalDragStart: (details) {
                    //   setState(() {
                    //     horizontalPosition = details.globalPosition;
                    //   });
                    // },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx.isNegative) {
                        setState(() {
                          horizontalPosition = const Offset(defaultPadding, 0);
                        });
                      }
                      if (details.globalPosition.dx <= widgetWidth - 80) {
                        setState(() {
                          horizontalPosition = details.globalPosition;
                        });
                      } else {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            slideComplete = true;
                            horizontalPosition =
                                const Offset(defaultPadding, 0);
                            widget.onComplete();
                          });
                        });
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (!slideComplete) {
                        setState(() {
                          horizontalPosition = const Offset(defaultPadding, 0);
                        });
                      }
                    },

                    child: Container(
                      height: widget.height ?? 50,
                      width: widget.height ?? 50,
                      child: const Icon(
                        FontAwesomeIcons.heartCirclePlus,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              ],
            ));
  }
}
