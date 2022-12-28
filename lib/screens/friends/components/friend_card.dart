import 'package:flutter/material.dart';

import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    Key? key,
    required this.friends,
  }) : super(key: key);

  final Friends friends;

  @override
  Widget build(BuildContext context) {
    Profile friend = friends.friendsProfile;
    return Container(
      // constraints: BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.symmetric(
          horizontal: defaultMargin, vertical: defaultMargin),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(6.0, 6.0),
              blurRadius: 16.0,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: friend.images
                    .map((e) => SoulCircleAvatar(
                          imageUrl: e.image,
                          radius: 12,
                        ))
                    .toList(),
              ),
              const SizedBox(
                width: defaultMargin,
              ),
              Text(
                friend.name,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Text(
              friend.bio,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: textBlack97),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Friends since: ${friends.dateAcceptedFormat}",
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
