import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.onPress,
      this.icon,
      required this.text,
      this.padding = const EdgeInsets.symmetric(vertical: defaultPadding * 3)})
      : super(key: key);
  final Function onPress;
  final Icon? icon;
  final String text;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          onPress();
        },
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? const SizedBox.shrink(),
              const SizedBox(
                width: defaultPadding,
              ),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        ));
  }
}

class SpotifyButton extends StatelessWidget {
  const SpotifyButton({Key? key, required this.onPress, required this.text})
      : super(key: key);
  final Function onPress;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: spotifyGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: () {
          onPress();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.spotify),
              const SizedBox(
                width: defaultPadding,
              ),
              Text(text)
            ],
          ),
        ));
  }
}

class RoundedIconButton extends StatefulWidget {
  const RoundedIconButton({
    Key? key,
    required this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final Color? color;
  final Function? onTap;

  @override
  State<RoundedIconButton> createState() => _RoundedIconButtonState();
}

class _RoundedIconButtonState extends State<RoundedIconButton> {
  bool update = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (tap) {
        setState(() {
          update = true;
        });
      },
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapUp: (tap) {
        setState(() {
          update = false;
        });
      },
      onTapCancel: () {
        setState(() {
          update = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        width: 40,
        height: 70,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(6.0, 6.0),
            blurRadius: 16.0,
          ),
        ], color: update ? widget.color : Colors.white, shape: BoxShape.circle),
        child: Center(
            child: Icon(
          widget.icon,
          color: update ? Colors.white : widget.color,
        )),
      ),
    );
  }
}
