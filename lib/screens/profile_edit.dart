import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/spotifyuser.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: _ProfileEditBody(),
      ),
      appBar: buildAppBar(context),
    );
  }
}

class _ProfileEditBody extends StatefulWidget {
  const _ProfileEditBody({
    Key? key,
  }) : super(key: key);
  @override
  State<_ProfileEditBody> createState() => __ProfileEditBodyState();
}

class __ProfileEditBodyState extends State<_ProfileEditBody> {
  // final SpotifyController spotifyController = Get.find<SpotifyController>();
  final SoulController soulController = Get.find<SoulController>();
  String selectedDate = DateTime(DateTime.now().year).toString();
  TextEditingController names = TextEditingController();
  TextEditingController bio = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    names.text = soulController.profile!.name;
    bio.text = soulController.profile!.bio;
    selectedDate = soulController.profile!.dateOfBirth.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SpotifyUser? user = soulController.spotify.currentUser;
    return ListView(
      padding: scrollPadding,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipOval(
                child: CachedNetworkImage(
              imageUrl: user!.image,
              width: 35,
              height: 35,
            )),
            const SizedBox(
              width: defaultPadding,
            ),
            Text(
              user.displayName,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: Text(
            "Update your Souldate profile",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthField(
                hintText: "Full Names",
                controller: names,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Field is required";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                child: DateTimeFormField(
                  initialValue: soulController.profile!.dateOfBirth,
                  initialDate: DateTime.tryParse(selectedDate),
                  initialDatePickerMode: DatePickerMode.year,
                  validator: (DateTime? selected) {
                    if (selected == null) {
                      return "Your Date Of Birth is required";
                    } else if (DateTime.now().difference(selected).inDays <
                        (18 * 365)) {
                      return "You do not meet the age requirements";
                    }
                    return null;
                  },
                  mode: DateTimeFieldPickerMode.date,
                  dateFormat: DateFormat("yyyy-MM-d"),
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = DateFormat("yyyy-MM-d").format(date);
                    });
                  },
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                      focusColor: Colors.black,
                      suffixIconColor: Colors.black,
                      suffixIcon: const Icon(Icons.calendar_month),
                      hintText: "Date Of Birth",
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      hintStyle: Theme.of(context).textTheme.caption),
                ),
              ),
              AuthTextArea(
                hintText: "Your Bio",
                controller: bio,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: PrimaryButton(
            onPress: () {
              if (formKey.currentState!.validate()) {
                Map<String, String> body = {
                  "bio": bio.text,
                  "name": names.text,
                  "date_of_birth": DateFormat("yyyy-MM-d")
                      .format(DateTime.parse(selectedDate))
                      .toString()
                };
                soulController.updateProfile(body, context: context);
              }
            },
            text: "Update Profile",
            icon: const Icon(Icons.person),
          ),
        )
      ],
    );
  }
}
