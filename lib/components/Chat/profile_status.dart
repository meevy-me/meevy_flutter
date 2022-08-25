import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/models/profile_model.dart';

class ProfileStatus extends StatefulWidget {
  const ProfileStatus({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  State<ProfileStatus> createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  late DatabaseReference db;
  @override
  void initState() {
    db = FirebaseDatabase.instance.ref('user_status/${widget.profile.id}');
    db.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final val = event.snapshot.value! as Map;
        if (val['status'] == 'online') {
          if (mounted) {
            setState(() {
              online = true;
              lastSeen = DateTime.parse(val['last_updated']);
            });
          }
        } else {
          if (mounted) {
            setState(() {
              online = false;
            });
          }
        }
      }
    });

    super.initState();
  }

  bool online = false;
  DateTime? lastSeen;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.profile.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: online ? Colors.green : Colors.grey,
                  shape: BoxShape.circle),
            )
          ],
        ),
        if (lastSeen != null)
          Text(
            "For ${DateTime.now().difference(lastSeen!).inMinutes} minutes",
            style: Theme.of(context).textTheme.caption,
          )
      ],
    );
  }
}
