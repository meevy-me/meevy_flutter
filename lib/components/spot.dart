import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/spots.dart';
import 'package:soul_date/screens/spot_screen.dart';

class SpotWidget extends StatelessWidget {
  const SpotWidget({
    this.mine = false,
    this.onTap,
    this.spots,
    Key? key,
  }) : super(key: key);
  final bool mine;
  final SpotsView? spots;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    Spot spot = spots!.spots.last;
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => SpotScreen(spots: spots!));
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(0.7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: spotifyGreen, width: 0.7)),
                child: Container(
                  padding: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: spotifyGreen, width: 0.5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: spot.profile.images.last['image'],
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              Hero(
                tag: spot.details.item.album.images[0].url +
                    spot.profile.id.toString(),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  radius: 10,
                  foregroundImage: CachedNetworkImageProvider(
                      spot.details.item.album.images[0].url),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Text(mine ? "My Spot" : spot.profile.name.split(" ")[0],
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.white)),
        )
      ],
    );
  }
}
