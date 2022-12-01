import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

import '../models/profile_model.dart';

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

class SoulSliderCheck extends StatelessWidget {
  SoulSliderCheck({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;
  final SoulController controller = Get.find<SoulController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: controller.isFriendRequested(profile),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Center(
                    child: snapshot.data != null &&
                            snapshot.hasData &&
                            snapshot.data!
                        ? Text(
                            ":( You already sent a request",
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SoulSlider(
                            completedWidget:
                                const Text("You have sent a request"),
                            defaultText: "Slide to match with ${profile.name}",
                            onComplete: () {
                              controller.sendRequest(
                                  {'profile2': profile.id.toString()},
                                  context: context);
                            },
                          ),
                    // child: SlideToLike(
                    //     match: match.matched,
                    //     onLiked: (value) {
                    //       controller.sendRequest({'matchID': match.id.toString()},
                    //           context: context);
                    //     })
                  ),
                )
              : SpinKitRing(
                  color: Theme.of(context).primaryColor,
                  lineWidth: 2,
                  size: 20,
                );
        });
  }
}
