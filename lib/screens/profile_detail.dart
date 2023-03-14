import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/custom_slider.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home/components/profile_detail_favourites.dart';
import 'package:soul_date/services/cache.dart';

import '../components/pulse.dart';
import '../models/models.dart';
import 'home/components/profile_detail_method_selector.dart';
import 'home/components/profile_image_widget.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen(
      {Key? key, this.match, required this.profile, this.images})
      : super(key: key);
  final Match? match;
  final Profile profile;
  final List<ProfileImages>? images;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  double _bottomHeight = 70;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _mainSize =
        size.height - MediaQuery.of(context).viewInsets.top - _bottomHeight;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            _ProfileDetailBody(
              mainSize: _mainSize,
              profile: widget.profile,
              match: widget.match,
            ),
            Positioned(
              bottom: 0,
              child: SoulSliderCheck(
                profile: widget.profile,
                height: _bottomHeight - 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailBody extends StatefulWidget {
  const _ProfileDetailBody({
    Key? key,
    required double mainSize,
    required this.profile,
    this.match,
  })  : _mainSize = mainSize,
        super(key: key);

  final double _mainSize;
  final Profile profile;
  final Match? match;

  @override
  State<_ProfileDetailBody> createState() => _ProfileDetailBodyState();
}

class _ProfileDetailBodyState extends State<_ProfileDetailBody> {
  final SoulController soulController = Get.find<SoulController>();

  late Future<List<ProfileImages>> _future;
  @override
  void initState() {
    _future = getImages(widget.profile.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: widget._mainSize,
      margin: scaffoldPadding / 2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.4,
            child: FutureBuilder<List<ProfileImages>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return ProfileImageWidget(
                      images: snapshot.data!,
                      profile: widget.profile,
                      width: size.width,
                    );
                  }
                  return const LoadingPulse();
                }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.match != null
                      ? ProfileMatchMethod(
                          match: widget.match!,
                        )
                      : const SizedBox(height: defaultMargin),
                  // const Divider(
                  //   height: 0,
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bio",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              child: Text(
                                widget.profile.bio,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: textBlack97),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: ProfileDetailFavourites(
                      profile: widget.profile,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
