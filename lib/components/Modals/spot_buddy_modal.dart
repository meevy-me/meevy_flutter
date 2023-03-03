import 'package:flutter/material.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/spotify_profile_avatar.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/models/spot_buddy_model.dart';

class SpotBuddyModal extends StatelessWidget {
  const SpotBuddyModal({Key? key, required this.buddies, required this.spot})
      : super(key: key);
  final List<SpotBuddy> buddies;
  final Spot spot;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.4),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SpotBuddyProfile(buddies: buddies, size: size),
          const Divider(),
          Padding(
            padding: scaffoldPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SoulCircleAvatar(
                  imageUrl: spot.details.item.image,
                  radius: 18,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.details.item.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Text(
                          spot.details.item.caption,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotBuddyProfile extends StatefulWidget {
  const _SpotBuddyProfile({
    Key? key,
    required this.buddies,
    required this.size,
  }) : super(key: key);

  final List<SpotBuddy> buddies;
  final Size size;

  @override
  State<_SpotBuddyProfile> createState() => _SpotBuddyProfileState();
}

class _SpotBuddyProfileState extends State<_SpotBuddyProfile>
    with AutomaticKeepAliveClientMixin<_SpotBuddyProfile> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.size.height * 0.6,
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            itemCount: widget.buddies.length,
            itemBuilder: (context, index) {
              var buddy = widget.buddies[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoulCachedNetworkImage(
                    imageUrl: buddy.profile.profilePicture.image,
                    height: size.height * 0.35,
                    width: size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultMargin, vertical: defaultMargin * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buddy.profile.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Row(
                            children: [
                              Expanded(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: size.height * 0.1),
                                  child: Text(
                                    buddy.profile.bio,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        height: 1.4),
                                  ),
                                ),
                              ),
                              SpotifyProfileAvatar(profile: buddy.profile)
                            ],
                          ),
                        ),
                        buddy.caption != null
                            ? Text(
                                buddy.caption!,
                                style: Theme.of(context).textTheme.caption,
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (int i = 0; i < widget.buddies.length; i++)
            Container(
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
              width: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == selectedIndex ? Colors.white : Colors.grey),
            )
        ])
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
