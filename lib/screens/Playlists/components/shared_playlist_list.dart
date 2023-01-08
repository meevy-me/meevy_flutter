import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../components/cached_image_error.dart';
import '../../../components/icon_container.dart';
import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class SharedPlaylistList extends StatelessWidget {
  const SharedPlaylistList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //TODO: Change recepient
        stream: FirebaseFirestore.instance
            .collection('userSentPlaylists')
            .doc('2')
            .collection('sentPlaylists')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              primary: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: Container(
                    padding: scaffoldPadding,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              color: Colors.grey.withOpacity(0.3)),
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SoulCachedNetworkImage(
                            imageUrl: defaultArtistUrl,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(
                          width: defaultMargin,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hidden Gems",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: defaultPadding),
                              child: Row(
                                children: [
                                  SoulCircleAvatar(
                                    imageUrl: defaultGirlUrl,
                                    radius: 10,
                                  ),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Text(
                                    "Colinreece Kipkorir",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        IconContainer(
                          size: 35,
                          icon: Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return SpinKitPulse(
            color: Theme.of(context).primaryColor,
          );
        });
  }
}
