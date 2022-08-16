import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/components/loading.dart';
import 'package:soul_date/models/match_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/constants.dart';
import 'cached_image_error.dart';

class MatchImage extends StatelessWidget {
  const MatchImage({
    required this.match,
    Key? key,
  }) : super(key: key);

  final Match match;

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
              child: SoulCachedNetworkImage(
                imageUrl: match.matched.images.last.image,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, text, percentage) {
                  return const SizedBox(width: 20, child: Loading());
                },
              ),
            ),
          ),
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
                      "${match.matched.name}, ${match.matched.age}",
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
