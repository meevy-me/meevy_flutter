import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home/components/vinyl_list.dart';
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
  int? profileID;

  @override
  void initState() {
    getProfileID();
    super.initState();
  }

  void getProfileID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int id = preferences.getInt('profileID')!;
    setState(() {
      profileID = id;
    });
  }

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
              const SizedBox(
                height: defaultMargin,
              ),
              Padding(
                padding: scaffoldPadding,
                child: CurrentVinyl(
                  profileID: profileID,
                ),
              ),
              SizedBox(
                height: defaultMargin,
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
                          // Icon(
                          //   CupertinoIcons.play,
                          //   size: 20,
                          //   color: Colors.black,
                          // )
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
                          child: profileID != null
                              ? VinylList(profileID: profileID!)
                              : LoadingPulse(
                                  color: Theme.of(context).primaryColor,
                                ),
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
