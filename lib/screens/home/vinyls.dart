import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/home/components/vinyl_list.dart';

import 'components/current_vinyl.dart';

class VinylsPage extends StatefulWidget {
  const VinylsPage({Key? key}) : super(key: key);

  @override
  State<VinylsPage> createState() => _VinylsPageState();
}

class _VinylsPageState extends State<VinylsPage>
    with AutomaticKeepAliveClientMixin<VinylsPage> {
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

  @override
  bool get wantKeepAlive => true;
}
