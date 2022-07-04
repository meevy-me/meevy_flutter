import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:soul_date/components/loading.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';

class DataFetchPage extends StatefulWidget {
  const DataFetchPage(
      {Key? key, required this.accessToken, required this.refreshToken})
      : super(key: key);
  final String accessToken;
  final String refreshToken;

  @override
  State<DataFetchPage> createState() => _DataFetchPageState();
}

class _DataFetchPageState extends State<DataFetchPage> {
  final SpotifyController spotifyController = Get.find<SpotifyController>();
  @override
  void initState() {
    spotifyController.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Loading(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin),
            child: Text(
              "Please wait as we gather your data ",
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
