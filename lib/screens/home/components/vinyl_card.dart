import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/screens/home/vinyl_detail.dart';
import 'package:soul_date/services/spotify.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class VinylSentCard extends StatefulWidget {
  const VinylSentCard({
    Key? key,
    required this.vinyl,
  }) : super(key: key);
  final VinylModel vinyl;

  @override
  State<VinylSentCard> createState() => _VinylSentCardState();
}

class _VinylSentCardState extends State<VinylSentCard> {
  final SoulController soulController = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin),
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VinylDetail(vinyl: widget.vinyl),
              ));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.vinyl.item.album.images.last.url,
                height: 65,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.vinyl.sender.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      RowSuper(innerDistance: -10, children: [
                        for (Profile profile in widget.vinyl.audience)
                          SoulCircleAvatar(
                            imageUrl: profile.profilePicture.image,
                            radius: 10,
                          ),
                      ])
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextScroll(
                          "${widget.vinyl.item.name}  -  ${widget.vinyl.item.artists.first.name}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: defaultPadding),
                        //   child: TextScroll(
                        //     widget.vinyl.item.artists.first.name,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyText1!
                        //         .copyWith(
                        //             color:
                        //                 Theme.of(context).colorScheme.tertiary),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SoulCircleAvatar(
                        imageUrl: widget.vinyl.sender.profilePicture.image,
                        radius: 11,
                      ),
                      const SizedBox(
                        width: defaultMargin,
                      ),
                      Text(
                        widget.vinyl.caption ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: const Icon(
                FeatherIcons.moreHorizontal,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
