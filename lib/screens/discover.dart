import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/empty_widget.dart';
import 'package:soul_date/components/icon_container.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/profile_model.dart';

import '../components/inputfield.dart';
import '../components/pulse.dart';
import '../components/search_profile_dialog.dart';
import 'home/components/discover_match_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin<DiscoverPage> {
  final SoulController controller = Get.find<SoulController>();
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

  final TextEditingController searchField = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  RxBool loading = false.obs;
  @override
  void dispose() {
    scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.fetchMatches(loading: loading);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: scrollPadding,
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                controller.fetchMatches(loading: loading);
              });
            },
            color: Theme.of(context).primaryColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                _buildSliverAppbar(context),
                Obx(
                  () => loading.value
                      ? SliverToBoxAdapter(
                          child: LoadingPulse(
                              color: Theme.of(context).primaryColor),
                        )
                      : controller.matches.isNotEmpty
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                              // var matchesList = controller.matches[index];
                              return DiscoverMatch(
                                  match: controller.matches[index]);
                              // Match match = controller.matches[index];
                            }, childCount: controller.matches.length))
                          : SliverList(
                              delegate: SliverChildListDelegate([
                                EmptyWidget(
                                  text:
                                      "Don't lose hope! If you haven't found your music soulmates yet, why not try our app? Keep exploring and share to more users.",
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          elevation: 0),
                                      onPressed: () {
                                        controller.fetchMatches(
                                            loading: loading);
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text("Refresh")),
                                )
                              ]),
                            ),
                )
                // Obx(() => controller.matches.isNotEmpty
                //     ? SliverList(
                //         delegate: SliverChildBuilderDelegate((context, index) {
                //         return OpenContainer(
                //           openBuilder: (context, action) =>
                //               MatchDetail(profile:,),
                //           closedBuilder: (context, action) => Padding(
                //             padding:
                //                 const EdgeInsets.only(bottom: defaultMargin),
                //             child: MatchCard(
                //               onLiked: (match) {
                //                 controller.matches.remove(match);
                //               },
                //               match: controller.matches[index],
                //             ),
                //           ),
                //         );
                //       }, childCount: controller.matches.length))
                //     : const SliverToBoxAdapter(
                //         child: EmptyWidget(text: "Oops, you have no matches"),
                //       ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppbar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      titleSpacing: 0,
      pinned: true,
      title: Text(
        "Your Matches",
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        IconContainer(
            onPress: () {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);

              _focusNode.requestFocus();
            },
            color: _focusNode.hasFocus
                ? Colors.grey.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
            size: 40,
            icon: const Icon(
              Icons.search,
              color: Colors.black87,
              size: 25,
            )),
      ],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
              child: SoulField(
                focusNode: _focusNode,
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
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
