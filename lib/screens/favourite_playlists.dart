import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/components/spotify_favourite.dart';
import 'package:soul_date/components/spotify_search_result.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/my_spotify_playlists.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';

class FavouritePlaylistScreen extends StatefulWidget {
  const FavouritePlaylistScreen({Key? key}) : super(key: key);

  @override
  State<FavouritePlaylistScreen> createState() =>
      _FavouritePlaylistScreenState();
}

class _FavouritePlaylistScreenState extends State<FavouritePlaylistScreen> {
  final SoulController controller = Get.find<SoulController>();
  MySpotifyPlaylists? results;

  List<SpotifyFavouriteItem?> selected = [];
  ScrollController scrollController = ScrollController();
  Future<bool> uploadItems(List<SpotifyFavouriteItem?> items) async {
    return await controller.updateFavouritesPlaylist(items);
  }

  bool loading = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPlaylists();
    if (controller.favouritePlaylist.isNotEmpty) {
      var dataList =
          controller.favouritePlaylist.map((e) => e.details).toList();
      // int deficit = 4 - dataList.length;
      // for (int i = dataList.length - 1; i <= deficit; i++) {
      //   dataList.add(null);
      // }
      setState(() {
        selected = dataList;
      });
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
      floatingActionButton: selected.isNotEmpty
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
                var res = await uploadItems(selected);
                setState(() {
                  loading = false;
                });
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("That was a success")));
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
          "Favourite Playlists",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: const [],
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
                  selected.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selected.length,
                          itemBuilder: ((context, index) =>
                              SpotifyFavouriteWidget(
                                height: 95,
                                item: selected[index],
                                onRemove: (item) {
                                  setState(() {
                                    selected.remove(item);
                                  });
                                },
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Center(
                            child: Text(
                              "No Favourite Playlist. :(",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin),
                    child: Text(
                      "Your Playlists",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  results != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: results!.items.length,
                          itemBuilder: (context, index) {
                            var e = results!.items[index];
                            return SpotifyTrackResult(
                              selected: selected.contains(e),
                              result: e,
                              onClick: (item) {
                                if (!selected.contains(e) &&
                                    selected.length != 4) {
                                  setState(() {
                                    selected.add(item);
                                  });
                                } else if (selected.length == 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Only four playlists can be added")));
                                } else {
                                  setState(() {
                                    selected.remove(item);
                                  });
                                }
                              },
                            );
                          },
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
