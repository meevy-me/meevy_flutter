import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
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
  Tween<double> opacity = Tween(begin: 0, end: 1);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double widgetWidth = widget.width ?? size.width;

    return slideComplete
        ? widget.completedWidget
        : ConfirmationSlider(
            onConfirmation: () {
              setState(() {
                slideComplete = true;
              });
              widget.onComplete();
            },
            iconColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).primaryColor,
            shadow: BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(6.0, 6.0),
              blurRadius: 16.0,
            ),
            sliderButtonContent: const Icon(
              FontAwesomeIcons.heartCirclePlus,
              color: Colors.white,
            ),
            text: "Slide to send pair request",
            textStyle: Theme.of(context).textTheme.caption,
          );
  }
}
