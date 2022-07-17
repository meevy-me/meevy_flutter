import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/slider.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/profile_model.dart';

class SearchProfileDialog extends StatelessWidget {
  SearchProfileDialog({Key? key, required this.profile}) : super(key: key);
  final Profile profile;
  final SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: scaffoldPadding * 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: profile.images
                    .map((e) => SoulCircleAvatar(
                          imageUrl: e.image,
                          radius: 12,
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: Text(
                "${profile.name}, ${profile.age}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              profile.bio,
              style: Theme.of(context).textTheme.caption,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
              child: SlideToLike(
                  match: profile,
                  onLiked: (profile) {
                    controller.sendRequest({'profile2': profile.id.toString()},
                        context: context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
