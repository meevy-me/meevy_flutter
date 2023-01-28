import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/constants.dart';
import '../models/Spotify/base_model.dart';
import '../models/models.dart';
import '../services/spotify.dart';
import 'image_circle.dart';

class SpotifyProfileAvatar extends StatefulWidget {
  const SpotifyProfileAvatar({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  State<SpotifyProfileAvatar> createState() => _SpotifyProfileAvatarState();
}

class _SpotifyProfileAvatarState extends State<SpotifyProfileAvatar> {
  late Future<SpotifyData?> _future;

  @override
  void initState() {
    _future = Spotify().getItem('user', widget.profile.user.spotifyId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpotifyData?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPulse(
              color: spotifyGreen,
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return GestureDetector(
              onTap: () {
                Spotify().openSpotify(snapshot.data!.uri, snapshot.data!.url);
              },
              child: Container(
                  padding: scaffoldPadding / 3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: spotifyGreen)),
                  child: SoulCircleAvatar(imageUrl: snapshot.data!.image)),
            );
          }
          return IconButton(
              onPressed: () async {
                launchUrlString(
                    "https://open.spotify.com/user/${widget.profile.user.spotifyId}");
              },
              icon: const Icon(
                FontAwesomeIcons.spotify,
                color: Colors.white,
                size: 35,
              ));
        });
  }
}
