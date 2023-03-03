import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/messaging_utils.dart';
import 'package:soul_date/services/navigation.dart';
import 'package:soul_date/services/spotify_utils.dart';

class ShareDataScreen extends StatefulWidget {
  const ShareDataScreen({Key? key, this.sharedText, this.spotifyItem})
      : super(key: key);
  final String? sharedText;
  final Item? spotifyItem;

  @override
  State<ShareDataScreen> createState() => _ShareDataScreenState();
}

class _ShareDataScreenState extends State<ShareDataScreen> {
  // final SoulController soulController = Get.put(SoulController());
  final TextEditingController searchText = TextEditingController();
  final TextEditingController captionText = TextEditingController();
  List<Friends> selectedFriends = [];
  List<Friends> friends = [];
  List<Friends> friendsImmutable = [];
  // late Future<SpotifyData?> futureSpotifyData;
  SpotifyData? spotifyData;

  int? currentProfileId;
  @override
  void initState() {
    fillSpotifyData();
    fillFriends();
    super.initState();
  }

  fillSpotifyData() async {
    SpotifyData? data = await dataFromUrl(widget.sharedText!);
    setState(() {
      spotifyData = data;
    });
  }

  void fillFriends() async {
    var friendTemp = await getFriends();
    setState(() {
      friends = friendTemp;
      friendsImmutable = friends;
    });
  }

  void searchFriend(String query) {
    if (query == "") {
      setState(() {
        friends = friendsImmutable;
      });
    } else {
      final suggestions = friends.where((friend) {
        return friend.friendsProfile.name
            .toLowerCase()
            .contains(query.toLowerCase());
      });
      setState(() {
        friends = suggestions.toList();
      });
    }
  }

  Future<List<Friends>> getFriends() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int? profileID = preferences.getInt('profileID');

    setState(() {
      currentProfileId = profileID;
    });

    if (profileID != null) {
      var snapshots = await FirebaseFirestore.instance
          .collection('userFriends')
          .doc(profileID.toString())
          .collection('friends')
          .get();

      var friendsSnapshot =
          snapshots.docs.map((e) => Friends.fromJson(e.data())).toList();
      return friendsSnapshot;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            Container(
              height: size.height - 80,
              width: size.width,
              margin: scaffoldPadding / 2,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: SafeArea(
                child: Padding(
                  padding: scaffoldPadding,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              IconContainer(
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                onPress: () => Navigation.pop(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultMargin),
                                child: Text(
                                  "Send to friends",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultMargin),
                            child: SizedBox(
                              height: 45,
                              child: CupertinoSearchTextField(
                                // controller: captionText,
                                onChanged: searchFriend,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          primary: false,
                          children: [
                            currentProfileId != null
                                ? ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: friends.length,
                                    itemBuilder: (context, index) {
                                      Friends friend = friends[index];

                                      Profile friendsProfile =
                                          friend.friendsProfileSafe(
                                              currentProfileId!);
                                      return InkWell(
                                        onTap: () {
                                          if (selectedFriends
                                              .contains(friend)) {
                                            setState(() {
                                              selectedFriends.remove(friend);
                                            });
                                          } else {
                                            setState(() {
                                              selectedFriends.add(friend);
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: defaultMargin),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SoulCircleAvatar(
                                                  imageUrl: friendsProfile
                                                      .profilePicture.image),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                            defaultMargin),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      friendsProfile.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical:
                                                                defaultPadding),
                                                        child: Text(
                                                          friendsProfile.bio,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    color: selectedFriends
                                                            .contains(friend)
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.grey,
                                                    shape: BoxShape.circle),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : SpinKitPulse(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Builder(builder: (context) {
                if (spotifyData != null) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultMargin, vertical: defaultMargin),
                    height: 70,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: defaultPadding),
                        //   child: RowSuper(
                        //       innerDistance: -10,
                        //       children: selectedFriends
                        //           .map((e) => DelayedDisplay(
                        //                 delay:
                        //                     const Duration(milliseconds: 100),
                        //                 child: SoulCircleAvatar(
                        //                   imageUrl: e
                        //                       .friendsProfileSafe(
                        //                           currentProfileId!)
                        //                       .profilePicture
                        //                       .image,
                        //                   radius: 10,
                        //                 ),
                        //               ))
                        //           .toList()),
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SoulCircleAvatar(
                                    imageUrl: spotifyData!.image,
                                    radius: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    child: Row(
                                      children: [
                                        Text(
                                          spotifyData!.itemName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(color: Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          width: 5,
                                          height: 5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding),
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle),
                                        ),
                                        Text(
                                          spotifyData!.caption,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PrimarySendButton(
                              enabled: spotifyData != null &&
                                  selectedFriends.isNotEmpty,
                              onTap: () {
                                if (spotifyData != null &&
                                    selectedFriends.isNotEmpty) {
                                  for (var friend in selectedFriends) {
                                    sendMessage(
                                        friends: friend, msg: spotifyData!.url);
                                  }
                                  Navigation.pop(context);
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
                return LoadingPulse();
              }),
            )
          ],
        ),
      ),
    );
  }
}
