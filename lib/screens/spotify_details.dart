import 'package:flutter/material.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/spotifyuser.dart';

class SpotifyDetailsPage extends StatelessWidget {
  const SpotifyDetailsPage({Key? key, required this.spotifyUser})
      : super(key: key);
  final SpotifyUser spotifyUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text(
          "My Spotify",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Center(
        child: Padding(
          padding: scaffoldPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SoulCircleAvatar(imageUrl: spotifyUser.image, radius: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: Text(
                  spotifyUser.displayName,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SpotifyButton(onPress: () {}, text: "View Profile")
            ],
          ),
        ),
      ),
    );
  }
}
