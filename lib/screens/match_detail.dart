import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/custom_slider.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/components/spotify_card.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/Spotify/user_model.dart';
import 'package:soul_date/models/match_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/spotify.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MatchDetail extends StatelessWidget {
  const MatchDetail({Key? key, this.matchDetails, required this.profile})
      : super(key: key);
  final List<Details>? matchDetails;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height * 0.6,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height * 0.6,
                  child: ScrollImage(
                    heroTag: profile.id.toString(),
                    size: size.height * 0.6,
                    images: profile.images.reversed.toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.1),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: scaffoldPadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SafeArea(
                                child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ))),
                            _MatchDetails(
                              profile: profile,
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultMargin * 2, horizontal: defaultMargin),
              height: size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  matchDetails != null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: _MatchProfile(
                            details: matchDetails!,
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Me",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                profile.bio,
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SoulSliderCheck(
                    profile: profile,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MatchProfile extends StatelessWidget {
  _MatchProfile({
    Key? key,
    required this.details,
  }) : super(key: key);

  final List<Details> details;
  final SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Matching by: ",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: details.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: defaultMargin),
                  child: SpotifyCard(
                    details: details[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollImage extends StatefulWidget {
  const ScrollImage({
    Key? key,
    required this.images,
    required this.size,
    required this.heroTag,
  }) : super(key: key);

  final List images;
  final double size;
  final String heroTag;

  @override
  State<ScrollImage> createState() => _ScrollImageState();
}

class _ScrollImageState extends State<ScrollImage> {
  @override
  void initState() {
    super.initState();
  }

  DragStartDetails? startVerticalDragDetails;
  DragUpdateDetails? updateVerticalDragDetails;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        double dx = updateVerticalDragDetails!.globalPosition.dx -
            startVerticalDragDetails!.globalPosition.dx;
        double dy = updateVerticalDragDetails!.globalPosition.dy -
            startVerticalDragDetails!.globalPosition.dy;
        double? velocity = endDetails.primaryVelocity;
        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;

        if (velocity! < 0) {
          if (selectedIndex != widget.images.length - 1) {
            setState(() {
              selectedIndex += 1;
            });
          }
        } else {
          if (selectedIndex > 0) {
            setState(() {
              selectedIndex--;
            });
          }
        }
      },
      child: Stack(
        children: [
          SizedBox(
            height: widget.size,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: widget.images[selectedIndex].image,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              margin: EdgeInsets.only(
                  bottom: widget.size * 0.6 / (selectedIndex + 1),
                  top: widget.size * 0.2,
                  right: defaultMargin),
              height: (widget.size * 0.7) / (widget.images.length + 1),
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }
}

class _MatchDetails extends StatefulWidget {
  const _MatchDetails({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<_MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<_MatchDetails> {
  late Future<SpotifyData?> _future;
  @override
  void initState() {
    _future = Spotify().getItem('user', widget.profile.user.spotifyId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Icon(
              //   FontAwesomeIcons.personDress,
              //   size: 25,
              //   color: Colors.white,
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultMargin / 2),
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
          FutureBuilder<SpotifyData?>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPulse(
                    color: spotifyGreen,
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return GestureDetector(
                    onTap: () {
                      Spotify()
                          .openSpotify(snapshot.data!.uri, snapshot.data!.url);
                    },
                    child: Container(
                        padding: scaffoldPadding / 3,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: spotifyGreen)),
                        child:
                            SoulCircleAvatar(imageUrl: snapshot.data!.image)),
                  );
                }
                return IconButton(
                    onPressed: () async {
                      launchUrlString(
                          "https://open.spotify.com/user/${widget.profile.user.spotifyId}");
                    },
                    icon: const Icon(
                      FontAwesomeIcons.spotify,
                      color: Colors.white,
                      size: 35,
                    ));
              })
        ],
      ),
    );
  }
}
