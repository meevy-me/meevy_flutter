import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soul_date/components/spotify_favourite.dart';
import 'package:soul_date/components/spotify_search_result.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';
import 'package:soul_date/services/queue.dart';

class FavouritePlaylistScreen extends StatefulWidget {
  const FavouritePlaylistScreen({Key? key}) : super(key: key);

  @override
  State<FavouritePlaylistScreen> createState() =>
      _FavouritePlaylistScreenState();
}

class _FavouritePlaylistScreenState extends State<FavouritePlaylistScreen> {
  final SoulController controller = Get.find<SoulController>();
  MySpotifyPlaylists? results;
  SoulQueue<SpotifyFavouriteItem?> selected =
      SoulQueue.fromList(List.generate(4, (index) => null, growable: false));
  ScrollController scrollController = ScrollController();
  Future<bool> updateItem(List<SpotifyFavouriteItem?> items) async {
    return await controller.updateFavouritesPlaylist(items);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPlaylists();
    if (controller.favouritePlaylist.isNotEmpty) {
      selected = SoulQueue.fromList(
          controller.favouritePlaylist.map((e) => e!.details).toList());
    }
    scrollController.addListener(() async {
      var nextPageTrigger = scrollController.position.maxScrollExtent * 0.8;
      if (scrollController.position.pixels > nextPageTrigger) {
        if (results != null && results!.next != null) {
          MySpotifyPlaylists? res =
              await controller.spotify.myPlaylists(nextEndpoint: results!.next);

          if (res != null && res.next != results!.next) {
            setState(() {
              results!.items.addAll(res.items);
              results!.next = res.next;
            });
          }
        }
      }
    });
    super.initState();
  }

  void getPlaylists() async {
    var res = await controller.spotify.myPlaylists();
    setState(() {
      results = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Favourite Playlists",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 3),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0),
                onPressed: () {
                  if (selected.isNotEmpty) {
                    updateItem(selected.items);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(":) Favourite Playlists updated")));
                  }
                },
                child: const Text("Update")),
          )
        ],
      ),
      body: ListView(
        padding: scrollPadding,
        controller: scrollController,
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: ((context, index) => SpotifyFavouriteWidget(
                          height: 95,
                          item: selected.get(index),
                          onRemove: (item) {
                            setState(() {
                              selected.removeWhere((element) {
                                if (element != null) {
                                  return element.id == item.id;
                                } else {
                                  return false;
                                }
                              });
                            });
                          },
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: Text(
                      "Your Playlists",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  if (results != null)
                    ...results!.items
                        .map(
                          (e) => SpotifyTrackResult(
                              disabled: selected.isFull,
                              result: e,
                              onSelected: (item) {
                                setState(() {
                                  if (!selected.contains(item)) {
                                    selected.add(item);
                                  }
                                });
                              },
                              onDeselect: (item) {
                                setState(() {
                                  selected.removeWhere(
                                      (element) => element!.id == item.id);
                                });
                              }),
                        )
                        .toList()
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
