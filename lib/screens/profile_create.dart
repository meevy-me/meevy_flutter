import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:soul_date/components/appbar.dart';
import 'package:soul_date/components/authfield.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/gender_button.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/AuthController.dart';
import 'package:soul_date/models/spotifyuser.dart';

class ProfileCreatePage extends StatelessWidget {
  const ProfileCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: const _ProfileCreatePageBody(),
      appBar: buildAppBar(context),
    ));
  }
}

class _ProfileCreatePageBody extends StatefulWidget {
  const _ProfileCreatePageBody({Key? key}) : super(key: key);

  @override
  State<_ProfileCreatePageBody> createState() => __ProfileCreatePageBodyState();
}

class __ProfileCreatePageBodyState extends State<_ProfileCreatePageBody> {
  final SpotifyController spotifyController = Get.find<SpotifyController>();
  String selectedDate = DateTime(DateTime.now().year).toString();
  TextEditingController names = TextEditingController();
  TextEditingController bio = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedGender = 'M';

  @override
  void dispose() {
    names.dispose();
    bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SpotifyUser? user = spotifyController.spotify.currentUser;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: LoadingPulse(color: Theme.of(context).primaryColor),
      ),
      child: ListView(
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
                fit: BoxFit.cover,
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
              "Create your Meevy profile",
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
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultMargin * 2),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Audience",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: defaultMargin,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GenderButton(
                              text: "Male",
                              active: selectedGender == 'M',
                              onPress: () {
                                setState(() {
                                  selectedGender = 'M';
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: defaultMargin,
                          ),
                          Expanded(
                            child: GenderButton(
                              text: "Female",
                              active: selectedGender == 'F',
                              onPress: () {
                                setState(() {
                                  selectedGender = 'F';
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: defaultMargin,
                          ),
                          Expanded(
                            child: GenderButton(
                              text: "Both",
                              active: selectedGender == 'A',
                              onPress: () {
                                setState(() {
                                  selectedGender = 'A';
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultMargin),
                  child: DateTimeFormField(
                    initialDate: DateTime.now(),
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
                  validator: (validator) {
                    if (validator == null || validator.isEmpty) {
                      return "Your bio cannot be empty.";
                    }
                    return null;
                  },
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
                    "date_of_birth": selectedDate,
                    'looking_for': selectedGender,
                  };

                  spotifyController.createProfile(body, context: context);
                }
              },
              text: "Create Profile",
              icon: const Icon(Icons.person),
            ),
          )
        ],
      ),
    );
  }
}
