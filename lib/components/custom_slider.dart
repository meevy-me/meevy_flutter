import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:soul_date/components/pulse.dart';
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
  final void Function() onComplete;
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
    return SizedBox(
      width: size.width,
      height: widget.height!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: SlideAction(
          elevation: 0,
          sliderRotate: false,
          onSubmit: widget.onComplete,
          borderRadius: 20,
          sliderButtonIconPadding: defaultMargin,
          innerColor: Theme.of(context).primaryColor,
          outerColor: Colors.grey.withOpacity(0.2),
          text: widget.defaultText,
          textStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white70),
          sliderButtonIcon: const Icon(
            FontAwesomeIcons.heartCirclePlus,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SoulSliderCheck extends StatefulWidget {
  const SoulSliderCheck({
    Key? key,
    required this.profile,
    this.height,
  }) : super(key: key);

  final Profile profile;
  final double? height;

  @override
  State<SoulSliderCheck> createState() => _SoulSliderCheckState();
}

class _SoulSliderCheckState extends State<SoulSliderCheck> {
  final SoulController controller = Get.find<SoulController>();
  late Future<bool> _future;

  @override
  void initState() {
    _future = controller.isFriendRequested(widget.profile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.profile.id != controller.profile!.id
        ? SizedBox(
            width: size.width,
            child: FutureBuilder<bool>(
                future: _future,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? Center(
                          child: snapshot.data != null &&
                                  snapshot.hasData &&
                                  snapshot.data!
                              ? Container(
                                  height: widget.height,
                                  width: widget.height,
                                  padding: const EdgeInsetsDirectional.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : SoulSlider(
                                  height: widget.height,
                                  completedWidget:
                                      const Text("You have sent a request"),
                                  defaultText:
                                      "Slide to match with ${widget.profile.name}",
                                  onComplete: () async {
                                    await controller.sendRequest({
                                      'profile2': widget.profile.id.toString()
                                    }, context: context);

                                    setState(() {});
                                  },
                                ),
                          // child: SlideToLike(
                          //     match: match.matched,
                          //     onLiked: (value) {
                          //       controller.sendRequest({'matchID': match.id.toString()},
                          //           context: context);
                          //     })
                        )
                      : const LoadingPulse();
                }),
          )
        : SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "This is you. Nice :)",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: textBlack97),
                ),
              ),
            ),
          );
  }
}
