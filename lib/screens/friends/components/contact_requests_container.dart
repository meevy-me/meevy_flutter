import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/Phone/phone_auth.dart';
import 'package:soul_date/services/contacts.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import 'friend_request_profile_card.dart';

class ContactsRequestContainer extends StatefulWidget {
  const ContactsRequestContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactsRequestContainer> createState() =>
      _ContactsRequestContainerState();
}

class _ContactsRequestContainerState extends State<ContactsRequestContainer> {
  List<Profile> profiles = [];
  final SoulController soulController = Get.find<SoulController>();
  @override
  void initState() {
    syncContacts();
    super.initState();
  }

  void syncContacts() async {
    var items = await getContactProfiles();
    setState(() {
      profiles = items;
    });
  }

  Future<bool> isAuthenticated() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && user.phoneNumber != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: scrollPadding,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(
            "Your Contacts On Meevy",
            style: Theme.of(context).textTheme.headline6,
          ),
          FutureBuilder<bool>(
              future: isAuthenticated(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return snapshot.data!
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: profiles.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            Profile _profile = profiles[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultMargin),
                              child: ContactRequestProfileCard(
                                profile: _profile,
                                onAdd: (profile) async {
                                  await soulController
                                      .sendFriendRequest(profile);
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            children: [
                              Lottie.asset(
                                  'assets/images/hand-holding-phone.json',
                                  height: 200),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultMargin * 2),
                                child: PrimaryButton(
                                    onPress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PhoneAuthentication(),
                                          ));
                                    },
                                    text: "Verify Phone Number"),
                              ),
                            ],
                          ),
                        );
                } else {
                  return const SizedBox.shrink();
                }
              })
        ],
      ),
    );
  }
}
