import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/inputfield.dart';
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
  List<SpotifyFavouriteItem?> selected = List.generate(1, (index) => null);

  Future<bool> updateItem(SpotifyFavouriteItem item) async {
    return await controller.updateFavouritesTrack(item);
  }

  @override
  void initState() {
    if (controller.favouriteTrack != null) {
      selected[0] = controller.favouriteTrack!.details;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Favourite Song",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 3),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    primary: Theme.of(context).primaryColor),
                onPressed: () {
                  if (selected[0] != null) {
                    updateItem(selected[0]!);
                  }
                },
                child: const Text("Update")),
          )
        ],
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
                      item: selected[0],
                      onRemove: (item) {
                        setState(() {
                          var index = selected.indexWhere((element) {
                            if (element != null) {
                              return element.id == item.id;
                            } else {
                              return false;
                            }
                          });
                          selected[index] = null;
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
                return SpotifyTrackResult(
                  key: ValueKey(e.id),
                  disabled: selected.first != null,
                  onSelected: ((item) {
                    if (selected.isNotEmpty) {
                      setState(() {
                        selected[0] = item;
                        controller.keyDb['searchTrack'] = item.id;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Cannot add more than one item")));
                    }
                  }),
                  onDeselect: (item) {
                    setState(() {
                      var index = selected.indexWhere((element) {
                        if (element != null) {
                          return element.id == item.id;
                        } else {
                          return false;
                        }
                      });
                      selected[index] = null;
                      controller.keyDb.remove('searchTrack');
                    });
                  },
                  result: e,
                );
              })
          ],
        ),
      ),
    );
  }
}
