import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/animations/animations.dart';
import 'package:soul_date/components/inputfield.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/components/spotify_favourite.dart';
import 'package:soul_date/components/spotify_search_result.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart';

class FavouriteSongScreen extends StatefulWidget {
  const FavouriteSongScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteSongScreen> createState() => _FavouriteSongScreenState();
}

class _FavouriteSongScreenState extends State<FavouriteSongScreen> {
  final SoulController controller = Get.find<SoulController>();
  SpotifySearch? results;
  SpotifyFavouriteItem? selected;
  bool loading = false;
  Future<bool> uploadItem(SpotifyFavouriteItem item) async {
    return await controller.updateFavouritesTrack(item);
  }

  @override
  void initState() {
    if (controller.favouriteTrack != null) {
      selected = controller.favouriteTrack!.details;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: selected != null
          ? FloatingActionButton(
              child: !loading
                  ? const Icon(CupertinoIcons.cloud_upload_fill)
                  : const LoadingPulse(
                      color: Colors.grey,
                    ),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                var res = await uploadItem(selected!);
                setState(() {
                  loading = false;
                });
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(":) That was a success")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("An error has occured, Try again later")));
                }
              },
            )
          : const SizedBox.shrink(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Favourite Song",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [],
      ),
      body: Container(
        height: size.height * 0.8,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        child: ListView(
          padding: scrollPadding,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Current Favourite",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: Column(
                  children: [
                    SpotifyFavouriteWidget(
                      item: selected,
                      onRemove: (item) {
                        setState(() {
                          selected = null;
                        });
                      },
                    ),
                  ],
                ),
              )
            ]),
            Text(
              "Search",
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: SoulField(
                hintText: "Search a song",
                prefixIcon: const Icon(
                  FontAwesomeIcons.spotify,
                  color: spotifyGreen,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      controller.spotify
                          .searchItem(value)
                          .then((value) => results = value);
                    });
                  }
                },
              ),
            ),
            if (results != null)
              ...results!.tracks.items.map((e) {
                return SlideAnimation(
                  child: SpotifyTrackResult(
                    key: ValueKey(e.id),
                    selected: selected != null ? e.id == selected!.id : false,
                    // disabled: selected.first != null,

                    onClick: (item) {
                      setState(() {
                        selected = item;
                      });
                    },
                    result: e,
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
