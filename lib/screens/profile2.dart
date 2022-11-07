import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/components/radio_container.dart';
import 'package:soul_date/components/secondary_input.dart';
import 'package:soul_date/components/soul_spotify_border.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class ProfileCreate extends StatefulWidget {
  const ProfileCreate({Key? key}) : super(key: key);

  @override
  State<ProfileCreate> createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreate> {
  final SoulController soulController = Get.find<SoulController>();
  DateTime? selectedDate;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  String target = 'A';
  int targetIndex = 0;

  @override
  void initState() {
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
                  const SizedBox(
                      width: 20,
                      child: IconContainer(icon: Icon(Icons.arrow_back_ios))),
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
                    SpotifyBorder(
                      padding: const EdgeInsets.all(defaultPadding / 2.5),
                      child: SoulCircleAvatar(
                        imageUrl: soulController.spotify.currentUser!.image,
                        radius: 50,
                      ),
                    ),
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
              selectedTarget: targetIndex,
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
  final int selectedTarget;
  final void Function(String value)? onChange;

  @override
  State<_TargetPick> createState() => _TargetPickState();
}

class _TargetPickState extends State<_TargetPick> {
  late int activeIndex;
  @override
  void initState() {
    activeIndex = widget.selectedTarget;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Audience",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: defaultMargin,
        ),
        Column(
          children: [
            RadioContainer(
              onTap: () {
                if (widget.onChange != null) {
                  widget.onChange!('M');
                }
                setState(() {
                  activeIndex = 0;
                });
              },
              active: activeIndex == 0,
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
                  activeIndex = 1;
                });
              },
              active: activeIndex == 1,
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
      ],
    );
  }
}
