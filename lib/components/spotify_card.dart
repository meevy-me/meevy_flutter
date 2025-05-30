import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/details_model.dart';

class SpotifyCard extends StatelessWidget {
  SpotifyCard({
    Key? key,
    required this.details,
  }) : super(key: key);

  final Details details;
  final SoulController controller = Get.find<SoulController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        controller.spotify.openSpotify(details.uri, details.spotifyLink);
        // launchUrlString(details.spotifyLink!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      CachedNetworkImageProvider(details.detailImage),
                  radius: 20),
              const SizedBox(
                width: defaultMargin,
              ),
              Text(
                details.artistName ?? details.name!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: spotifyGreen),
              ),
              const SizedBox(
                width: defaultMargin,
              ),
              Icon(
                FontAwesomeIcons.spotify,
                color: Colors.grey.withOpacity(0.6),
                size: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
