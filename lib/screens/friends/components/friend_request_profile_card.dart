import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';

class FriendRequestProfileCard extends StatefulWidget {
  const FriendRequestProfileCard({
    Key? key,
    required this.friend,
    this.onAccept,
  }) : super(key: key);
  final Friends friend;
  final void Function(Friends friend)? onAccept;
  @override
  State<FriendRequestProfileCard> createState() =>
      _FriendRequestProfileCardState();
}

class _FriendRequestProfileCardState extends State<FriendRequestProfileCard> {
  bool switchState = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SoulCircleAvatar(
          imageUrl: widget.friend.friendsProfile.profilePicture.image,
          radius: 21,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friend.friendsProfile.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    widget.friend.friendsProfile.bio,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption!,
                  ),
                )
              ],
            ),
          ),
        ),
        Switch.adaptive(
            inactiveTrackColor: Colors.grey,
            activeColor: Theme.of(context).primaryColor,
            value: switchState,
            onChanged: (value) {
              setState(() {
                switchState = value;
              });
              if (widget.onAccept != null) {
                widget.onAccept!(widget.friend);
              }
            })
      ],
    );
  }
}

class ContactRequestProfileCard extends StatelessWidget {
  const ContactRequestProfileCard({
    Key? key,
    required this.profile,
    this.onAdd,
  }) : super(key: key);
  final Profile profile;
  final void Function(Profile profile)? onAdd;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SoulCircleAvatar(
          imageUrl: profile.profilePicture.image,
          radius: 21,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    profile.bio,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption!,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (onAdd != null) {
              onAdd!(profile);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultMargin, vertical: defaultPadding),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(
                  FeatherIcons.userPlus,
                  size: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Add",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.w600, color: textBlack97),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
