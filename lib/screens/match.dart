import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/appbar_home.dart';
import 'package:soul_date/components/empty_widget.dart';
import 'package:soul_date/components/inputfield.dart';
import 'package:soul_date/components/match_card.dart';
import 'package:soul_date/components/search_profile_dialog.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/screens/match_detail.dart';
import 'package:collection/collection.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final SoulController controller = Get.find<SoulController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: buildHomeAppBar(context),
            body: _MatchScreenBody(
              controller: controller,
            )));
  }
}

class _MatchScreenBody extends StatelessWidget {
  _MatchScreenBody({Key? key, required this.controller}) : super(key: key);
  final SoulController controller;
  TextEditingController searchField = TextEditingController();

  void searchText(BuildContext context, String _text) async {
    String text = _text;
    String searchText = text;
    if (text.isNotEmpty) {
      if (text.contains("https://open.spotify.com/")) {
        var textf = text.replaceAll("https://open.spotify.com/", "");
        var keys = textf.split("/");
        var fieldId = keys[1];
        if (fieldId.contains("?")) {
          searchText = fieldId.split("?")[0];
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(":/ Not a valid Url")));
      }
      Profile? searchProfile = await controller.searchProfile(searchText);
      if (searchProfile == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(":/ Soul not found")));
      } else {
        showDialog(
            context: context,
            builder: (context) => SearchProfileDialog(profile: searchProfile));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          controller.fetchMatches();
        });
      },
      color: Theme.of(context).primaryColor,
      child: ListView(
        padding: scrollPadding,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultMargin, bottom: defaultMargin * 2),
            child: GestureDetector(
              onTap: () async {
                ClipboardData? text = await Clipboard.getData('text/plain');
                if (text != null && text.text != null) {
                  searchText(context, text.text!);
                }
              },
              child: SoulField(
                controller: searchField,
                activeColor: Theme.of(context).primaryColor,
                hintText: "Search by user spotify url",
                suffixIcon: IconButton(
                    onPressed: () async {
                      searchText(context, searchField.text);
                    },
                    icon: const Icon(Icons.search)),
                prefixIcon: const Icon(
                  FontAwesomeIcons.spotify,
                  color: spotifyGreen,
                ),
              ),
            ),
          ),
          Text(
            "Your Matches",
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin),
              child: Obx(() => controller.matches.isNotEmpty
                  ? Column(
                      children: controller.matches
                          .mapIndexed((index, element) => OpenContainer(
                                openBuilder: (context, action) => MatchDetail(
                                    match: controller.matches[index]),
                                closedBuilder: (context, action) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: defaultMargin),
                                  child: MatchCard(
                                    onLiked: (match) {
                                      controller.matches.remove(match);
                                    },
                                    match: controller.matches[index],
                                  ),
                                ),
                              ))
                          .toList())
                  : const EmptyWidget(
                      text: "No matches currently :/",
                    )))
        ],
      ),
    );
  }
}
