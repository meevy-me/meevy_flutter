import 'package:flutter/material.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/spots.dart';
import 'package:soul_date/screens/Spots/spot_screen.dart';
import 'package:soul_date/services/navigation.dart';

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
    Spot spot = spots!.spots.first;
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigation.push(context,
                customPageTransition: PageTransition(
                    child: SpotScreen(spots: spots!),
                    type: PageTransitionType.scaleUpWithFadeIn));
            // Navigator.push(
            //     context, scaledTransition(SpotScreen(spots: spots!)));
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(0.7),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 0.7)),
                child: Container(
                  padding: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 0.5)),
                  child: SoulCircleAvatar(
                    imageUrl: spot.details.item.album.images[0].url,
                    radius: 27,
                  ),
                ),
              ),
              ProfileAvatar(
                profileID: spot.profile.id,
                radius: 10,
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
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
        )
      ],
    );
  }
}
