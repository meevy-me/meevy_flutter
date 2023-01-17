import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/components/radio_container.dart';
import 'package:soul_date/components/secondary_input.dart';
import 'package:soul_date/components/soul_spotify_border.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/services/spotify.dart';

import '../models/profile_model.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final SoulController soulController = Get.find<SoulController>();
  DateTime? selectedDate;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  String target = 'A';
  late Future<SpotifyUser?> _future;
  @override
  void initState() {
    Profile _profile = soulController.profile!;
    name.text = _profile.name;
    bio.text = _profile.bio;
    target = _profile.looking_for;
    selectedDate = _profile.dateOfBirth;
    _future = Spotify().getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: scaffoldPadding,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultMargin),
              child: Row(
                children: [
                  SizedBox(
                      width: 20,
                      child: IconContainer(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPress: () => Navigator.pop(context),
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Profile",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: size.width, child: _buildProfileImage(context)),
                  const SizedBox(
                    height: defaultMargin * 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SecondaryTextInput(
                        label: "Display Name",
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          }
                          return null;
                        },
                        controller: name,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin * 4),
                          child: DateInputField(
                            selectedDate: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            initialDate: soulController.profile!.dateOfBirth,
                            label: "Date Of Birth",
                          )),
                      SecondaryTextInput(
                        label: "Bio",
                        maxLines: 5,
                        controller: bio,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: defaultMargin * 4,
            ),
            PrimaryButton(
              onPress: () {
                Map<String, String> body = {
                  "bio": bio.text,
                  "name": name.text,
                  "looking_for": target,
                  "date_of_birth":
                      DateFormat("yyyy-MM-d").format(selectedDate!).toString()
                };

                soulController.updateProfile(body, context: context);
              },
              text: "Update",
              icon: const Icon(Icons.sync),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FutureBuilder<SpotifyUser?>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            return SpotifyBorder(
                              padding:
                                  const EdgeInsets.all(defaultPadding / 2.5),
                              child: SoulCircleAvatar(
                                imageUrl: snapshot.data!.image,
                                radius: 50,
                              ),
                            );
                          }
                          return const LoadingPulse(
                            color: spotifyGreen,
                          );
                        }),
                    const Positioned(
                      bottom: -15,
                      right: 0,
                      left: 0,
                      child: IconContainer(
                        size: 40,
                        icon: Icon(
                          FontAwesomeIcons.spotify,
                          color: Colors.white,
                          size: 25,
                        ),
                        color: spotifyGreen,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: defaultMargin * 2,
                ),
                Text(
                  soulController.profile.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  soulController.profile!.birthday,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Positioned(
            right: defaultMargin * 2,
            child: _TargetPick(
              selectedTarget: target,
              onChange: (value) {
                setState(() {
                  target = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class _TargetPick extends StatefulWidget {
  const _TargetPick({
    Key? key,
    required this.selectedTarget,
    this.onChange,
  }) : super(key: key);
  final String selectedTarget;
  final void Function(String value)? onChange;

  @override
  State<_TargetPick> createState() => _TargetPickState();
}

class _TargetPickState extends State<_TargetPick> {
  late String activeTarget;
  @override
  void initState() {
    activeTarget = widget.selectedTarget;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Audience",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: defaultMargin,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                RadioContainer(
                  onTap: () {
                    if (widget.onChange != null) {
                      widget.onChange!('M');
                    }
                    setState(() {
                      activeTarget = 'M';
                    });
                  },
                  active: activeTarget == 'M',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.male,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultMargin * 1,
                ),
                RadioContainer(
                  onTap: () {
                    if (widget.onChange != null) {
                      widget.onChange!('F');
                    }
                    setState(() {
                      activeTarget = 'F';
                    });
                  },
                  active: activeTarget == 'F',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.female,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: defaultMargin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            RadioContainer(
              onTap: () {
                if (widget.onChange != null) {
                  widget.onChange!('A');
                }
                setState(() {
                  activeTarget = 'A';
                });
              },
              active: activeTarget == 'A',
              child: Icon(
                FontAwesomeIcons.peopleGroup,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
