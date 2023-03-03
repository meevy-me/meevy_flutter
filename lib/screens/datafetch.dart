import 'package:flutter/material.dart';

import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/services/spotify.dart';

class DataFetchPage extends StatefulWidget {
  const DataFetchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DataFetchPage> createState() => _DataFetchPageState();
}

class _DataFetchPageState extends State<DataFetchPage> {
  // final SpotifyController spotifyController = Get.find<SpotifyController>();
  @override
  void initState() {
    Spotify().fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          LoadingPulse(
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Text(
              "Please wait as we make your matches ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          )
        ]),
      )),
    );
  }
}
