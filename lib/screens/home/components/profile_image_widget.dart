import 'package:flutter/material.dart';
import 'package:soul_date/components/image_circle.dart';

import '../../../components/cached_image_error.dart';
import '../../../components/spotify_profile_avatar.dart';
import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({
    Key? key,
    required this.images,
    required this.profile,
    this.width,
    this.height,
  }) : super(key: key);
  final List<ProfileImages> images;
  final double? width;
  final double? height;
  final Profile profile;

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (value) {
              setState(() {
                activeIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return SizedBox(
                width: widget.width,
                child: Stack(
                  // alignment: Alignment.bottomCenter,
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      child: ShaderMask(
                        blendMode: BlendMode.multiply,
                        shaderCallback: (bounds) {
                          return LinearGradient(
                              end: Alignment.topCenter,
                              begin: Alignment.center,
                              colors: [
                                Colors.grey.withOpacity(0.4),
                                Colors.transparent
                              ]).createShader(bounds);
                        },
                        child: SoulCachedNetworkImage(
                          imageUrl: widget.images[activeIndex].image,
                          width: widget.width,
                          height: widget.height,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: widget.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultMargin),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: defaultMargin / 2),
                                        child: Text(
                                          "${widget.profile.name}, ${widget.profile.age}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SpotifyProfileAvatar(
                                    profile: widget.profile,
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultPadding / 2),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0;
                                          i < widget.images.length;
                                          i++)
                                        AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            opacity: i == activeIndex ? 1 : 0.5,
                                            child: SoulCircleAvatar(
                                              imageUrl: widget.images[i].image,
                                              radius: i == activeIndex ? 10 : 8,
                                            ),
                                          ),
                                        )
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
