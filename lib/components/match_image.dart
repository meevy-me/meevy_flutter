import 'package:flutter/material.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/models/match_model.dart';
import 'package:soul_date/services/cache.dart';

import '../constants/constants.dart';
import 'cached_image_error.dart';

class MatchImage extends StatefulWidget {
  const MatchImage({
    required this.profile,
    required this.matchElement,
    Key? key,
  }) : super(key: key);

  // final Match match;
  final Profile profile;
  final MatchElement matchElement;

  @override
  State<MatchImage> createState() => _MatchImageState();
}

class _MatchImageState extends State<MatchImage> {
  late Future<List<ProfileImages>> _future;
  @override
  void initState() {
    _future = getImages(widget.profile.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ShaderMask(
              blendMode: BlendMode.multiply,
              shaderCallback: (bounds) {
                return LinearGradient(
                    end: Alignment.topCenter,
                    begin: Alignment.center,
                    colors: [
                      Colors.grey.withOpacity(0.6),
                      Colors.transparent
                    ]).createShader(bounds);
              },
              child: FutureBuilder<List<ProfileImages>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty) {
                      return SoulCachedNetworkImage(
                        imageUrl: snapshot.data!.first.image,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, text, percentage) {
                          return SizedBox(
                              width: 20,
                              child: LoadingPulse(
                                color: Theme.of(context).primaryColor,
                              ));
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    return LoadingPulse(
                      color: Theme.of(context).primaryColor,
                    );
                  }),
            ),
          ),
        ),
        Positioned(
          top: defaultMargin,
          left: defaultMargin,
          child: MatchMethodWidget(widget: widget),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Icon(
                  //   FontAwesomeIcons.personDress,
                  //   size: 25,
                  //   color: Colors.white,
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin / 2),
                    child: Text(
                      "${widget.profile.name}, ${widget.profile.age}",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     const Icon(
                  //       FontAwesomeIcons.locationCrosshairs,
                  //       color: Colors.white,
                  //     ),
                  //     const SizedBox(
                  //       width: defaultPadding,
                  //     ),
                  //     // Text(
                  //     //   "Nairobi, Kenya",
                  //     //   style: Theme.of(context)
                  //     //       .textTheme
                  //     //       .bodyText1!
                  //     //       .copyWith(color: Colors.white),
                  //     // )
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MatchMethodWidget extends StatefulWidget {
  const MatchMethodWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final MatchImage widget;

  @override
  State<MatchMethodWidget> createState() => _MatchMethodWidgetState();
}

class _MatchMethodWidgetState extends State<MatchMethodWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 950),
      padding: const EdgeInsets.symmetric(
          vertical: defaultPadding, horizontal: defaultMargin),
      constraints: const BoxConstraints(
        minHeight: 30,
      ),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
                color: spotifyGreen, shape: BoxShape.circle),
          ),
          const SizedBox(
            width: defaultPadding,
          ),
          Text(
            widget.widget.matchElement.method,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
