import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/profile_action_button.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/screens/feedback.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: scrollPadding, children: [
          Row(children: const [
            IconContainer(
                icon: Icon(
              Icons.chevron_left,
              size: 30,
            )),
          ]),
          ProfileActionButton(
              iconData: CupertinoIcons.bell,
              title: "Notifications",
              onTap: () {},
              subtitle: "Configure your notifications"),
          ProfileActionButton(
              iconData: CupertinoIcons.bubble_left,
              title: "Feedback",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackScreen()));
              },
              subtitle: "For a chance at souldate pro")
        ]),
      ),
    );
  }
}
