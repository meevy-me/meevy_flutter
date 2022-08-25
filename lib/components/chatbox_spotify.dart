import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/chatbox.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';

class ChatSpotify extends StatelessWidget {
  const ChatSpotify({
    Key? key,
    required this.widget,
    required this.spotifyData,
  }) : super(key: key);

  final ChatBox widget;
  final SpotifyData? spotifyData;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SoulController>(builder: (controller) {
      return GestureDetector(
        onTap: (() async {
          if (spotifyData != null) {
            // if (await canLaunchUrlString(spotifyData!.url)) {
            controller.spotify.openSpotify(spotifyData!.uri, spotifyData!.url);
          }
        }),
        child: SizedBox(
          width: widget.width,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: spotifyData!.image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultMargin / 2, horizontal: defaultPadding),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.spotify,
                      color: spotifyGreen,
                      size: 15,
                    ),
                    const SizedBox(
                      width: defaultMargin,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spotifyData!.type.toUpperCase(),
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            spotifyData!.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            spotifyData!.caption,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
