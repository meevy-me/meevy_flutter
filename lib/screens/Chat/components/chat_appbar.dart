import 'package:flutter/material.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/services/navigation.dart';

import '../../../components/icon_container.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({
    Key? key,
    required this.friendsProfile,
  }) : super(key: key);
  final Profile friendsProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconContainer(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
          onPress: () => Navigation.pop(context),
        ),
        // const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileAvatar(
              profileID: friendsProfile.id,
              radius: 15,
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Text(
              friendsProfile.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
            )
          ],
        ),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }
}
