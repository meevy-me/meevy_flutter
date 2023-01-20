import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/match_detail.dart';
import 'package:soul_date/services/profile_utils.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key, required this.sharedText}) : super(key: key);
  final String sharedText;
  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  late Future<Profile?> _future;
  @override
  void initState() {
    _future = getProfile();
    super.initState();
  }

  Future<Profile?> getProfile() async {
    final pattern = RegExp(r'/app/invite/([a-zA-Z0-9_]+)');
    final match = pattern.firstMatch(widget.sharedText);
    if (match != null) {
      final id = match.group(1);
      if (id != null) {
        Profile? profile = await searchProfile(id);
        return profile;
      }
      // id is the extracted id from inviteLink
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Profile?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return MatchDetail(profile: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPulse(
                color: Theme.of(context).primaryColor,
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return Center(child: Text("Profile Not found"));
            }
            return const SizedBox();
          }),
    );
  }
}
