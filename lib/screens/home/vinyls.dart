import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/images.dart';

import 'components/current_vinyl.dart';
import 'components/vinyl_card.dart';

class VinylsPage extends StatefulWidget {
  const VinylsPage({Key? key}) : super(key: key);

  @override
  State<VinylsPage> createState() => _VinylsPageState();
}

class _VinylsPageState extends State<VinylsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: scaffoldPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello, Edwin",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    IconContainer(
                        icon: Icon(
                      CupertinoIcons.music_albums_fill,
                      color: Colors.white,
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: defaultMargin,
              ),
              Padding(
                padding: scaffoldPadding,
                child: CurrentVinyl(),
              ),
              SizedBox(
                height: defaultMargin * 2,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: scaffoldPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Songs From Friends",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            CupertinoIcons.play,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: defaultMargin),
                        child: Container(
                          // height: 450,
                          decoration: BoxDecoration(
                              color: const Color(0xFF241D1E),
                              borderRadius: BorderRadius.circular(0)),
                          child: StreamBuilder<QuerySnapshot>(
                              //TODO: Change to user profile
                              stream: FirebaseFirestore.instance
                                  .collection('userSentTracks')
                                  .doc('6')
                                  .collection('sentTracks')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                final userSnapshot = snapshot.data?.docs;
                                return ListView.separated(
                                  padding: scaffoldPadding,
                                  itemCount: userSnapshot != null
                                      ? userSnapshot.length
                                      : 0,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Colors.grey.withOpacity(0.2),
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    String doc_id = userSnapshot![index].id;
                                    return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('sentTracks')
                                            .doc(doc_id)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text("Something went wrong");
                                          }

                                          if (snapshot.data != null &&
                                              snapshot.hasData &&
                                              !snapshot.data!.exists) {
                                            return const SizedBox.shrink();
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            return VinylSentCard(
                                                vinyl: VinylModel.fromJson(
                                                    data, doc_id));
                                          }
                                          return SpinKitPulse(
                                            color: Colors.grey,
                                          );
                                        });
                                  },
                                );
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
