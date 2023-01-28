import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/components/Chat/chat_field.dart';
import 'package:soul_date/components/cached_image_error.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/Spotify/base_model.dart';
import 'package:soul_date/models/models.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Send to friends",
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.clear,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: scaffoldPadding,
        child: ListView(
          primary: false,
          children: [
            Builder(builder: (context) {
              if (spotifyData != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SoulCachedNetworkImage(
                        imageUrl: spotifyData!.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: Column(
                        children: [
                          Text(
                            spotifyData!.itemName,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding),
                            child: Text(
                              spotifyData!.caption,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          Text(
                            spotifyData!.spotifyDataType.name.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if (spotifyData == null) {
                return SpinKitPulse(
                  color: Theme.of(context).primaryColor,
                );
              }
              return const SizedBox.shrink();
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: SizedBox(
                height: 45,
                child: CupertinoSearchTextField(
                  // controller: captionText,
                  onChanged: searchFriend,
                ),
              ),
            ),
            SizedBox(
                height: size.height * 0.6,
                child: currentProfileId != null
                    ? ListView.builder(
                        // primary: false,
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          Friends friend = friends[index];

                          Profile friendsProfile =
                              friend.friendsProfileSafe(currentProfileId!);
                          return InkWell(
                            onTap: () {
                              if (selectedFriends.contains(friend)) {
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
                                      imageUrl:
                                          friendsProfile.profilePicture.image),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultMargin),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: defaultPadding),
                                            child: Text(
                                              friendsProfile.bio,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                        color: selectedFriends.contains(friend)
                                            ? Theme.of(context).primaryColor
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
                      )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: Row(
                children: selectedFriends
                    .map((e) => SoulCircleAvatar(
                          imageUrl: e
                              .friendsProfileSafe(currentProfileId!)
                              .profilePicture
                              .image,
                          radius: 15,
                        ))
                    .toList(),
              ),
            ),
            Visibility(
              visible: spotifyData != null && selectedFriends.isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChatTextField(captionText: captionText),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        if (spotifyData != null) {
                          sendSpotifyItem(
                              item: spotifyData!,
                              friends: selectedFriends,
                              caption: captionText.text);

                          captionText.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(CupertinoIcons.paperplane_fill))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
