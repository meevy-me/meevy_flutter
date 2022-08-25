import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/Chat/profile_status.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/spotify_favourite.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/favourite_model.dart';
import 'package:soul_date/models/models.dart';

import '../../constants/constants.dart';

class ChatProfileScreen extends StatefulWidget {
  const ChatProfileScreen({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: scrollPadding,
          children: [
            _buildCustomAppbar(widget.profile, context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: ChatProfileTab(onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: selectedIndex == 0
                  ? _ProfileDetailsTab(size: size, profile: widget.profile)
                  : _ProfileDetailFavourite(
                      profile: widget.profile,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailFavourite extends StatefulWidget {
  const _ProfileDetailFavourite({Key? key, required this.profile})
      : super(key: key);
  final Profile profile;

  @override
  State<_ProfileDetailFavourite> createState() =>
      _ProfileDetailFavouriteState();
}

class _ProfileDetailFavouriteState extends State<_ProfileDetailFavourite> {
  final SoulController controller = Get.find<SoulController>();
  FavouriteTrack? favouriteTrack;
  List<FavouritePlaylist?>? favouritePlaylists;

  @override
  void initState() {
    controller.getFriendFavouriteTrack(widget.profile.id).then((value) {
      setState(() {
        favouriteTrack = value;
      });
    });
    controller.getFriendFavouritePlaylist(widget.profile.id).then((value) {
      setState(() {
        favouritePlaylists = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favourite Song",
          style: Theme.of(context).textTheme.headline6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: SpotifyFavouriteWidget(
              onRemove: null,
              item: favouriteTrack == null ? null : favouriteTrack!.details),
        ),
        Padding(
          padding: const EdgeInsets.only(top: defaultMargin),
          child: Text("Favourite Playlist",
              style: Theme.of(context).textTheme.headline6),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Column(
            children: [
              if (favouritePlaylists != null)
                ...favouritePlaylists!
                    .map((e) => SpotifyFavouriteWidget(
                          onRemove: null,
                          item: e?.details,
                        ))
                    .toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileDetailsTab extends StatelessWidget {
  const _ProfileDetailsTab({
    Key? key,
    required this.size,
    required this.profile,
  }) : super(key: key);

  final Size size;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.photo,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
                const SizedBox(
                  width: defaultMargin,
                ),
                Text(
                  "Images",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(
              height: defaultMargin,
            ),
            SizedBox(
              height: size.height * 0.3,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: profile.validImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: defaultMargin * 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: size.width * 0.4,
                          imageUrl: profile.validImages[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.person_2_square_stack_fill,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                      const SizedBox(
                        width: defaultMargin,
                      ),
                      Text(
                        "Bio",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultMargin,
                  ),
                  Text(
                    profile.bio,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar_circle,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                        const SizedBox(
                          width: defaultMargin,
                        ),
                        Text(
                          "Date of Birth",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultMargin,
                    ),
                    Text(
                      DateFormat('dd-MMMM-yyyy').format(profile.dateOfBirth),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.spotify,
                color: spotifyGreen,
                size: 30,
              ),
              const SizedBox(
                width: defaultMargin,
              ),
              Text(
                "${profile.name}'s Spotify",
                style: GoogleFonts.poppins(
                    color: spotifyGreen,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
        )
      ],
    );
  }
}

class ChatProfileTab extends StatefulWidget {
  const ChatProfileTab({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(int index) onTap;

  @override
  State<ChatProfileTab> createState() => _ChatProfileTabState();
}

class _ChatProfileTabState extends State<ChatProfileTab> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ChatProfileTabWidget(
          onTap: () {
            setState(() {
              selectedIndex = 0;
            });
            widget.onTap(selectedIndex);
          },
          text: "Profile",
          enabled: selectedIndex == 0,
        ),
        _ChatProfileTabWidget(
          onTap: () {
            setState(() {
              selectedIndex = 1;
            });
            widget.onTap(selectedIndex);
          },
          text: "Favourites",
          enabled: selectedIndex == 1,
        ),
      ],
    );
  }
}

class _ChatProfileTabWidget extends StatelessWidget {
  const _ChatProfileTabWidget({
    Key? key,
    required this.text,
    required this.enabled,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final bool enabled;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: enabled
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      width: 2.5))),
          child: Center(
              child: Text(
            text,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: enabled ? null : defaultGrey),
          )),
        ),
      ),
    );
  }
}

Widget _buildCustomAppbar(Profile profile, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: defaultMargin),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const BackButton(),
            const SizedBox(
              width: defaultMargin,
            ),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SoulCircleAvatar(imageUrl: profile.validImages.last.image)
      ],
    ),
  );
}
