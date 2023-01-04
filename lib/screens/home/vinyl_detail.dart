import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:soul_date/components/Chat/chat_field.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/home/models/chat_model.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';
import 'package:soul_date/services/color_utils.dart';
import 'package:soul_date/services/images.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../constants/constants.dart';
import 'components/vinyl_chat_section.dart';
import 'components/vinyl_detail_bottombar.dart';
import 'components/vinyl_message_card.dart';

class VinylDetail extends StatefulWidget {
  const VinylDetail({Key? key, required this.vinyl}) : super(key: key);
  final VinylModel vinyl;

  @override
  State<VinylDetail> createState() => _VinylDetailState();
}

class _VinylDetailState extends State<VinylDetail> {
  final TextEditingController messageText = TextEditingController();
  final GlobalKey inputKey = GlobalKey();
  final SoulController soulController = Get.find<SoulController>();
  Future<PaletteGenerator>? _future;
  @override
  void initState() {
    _future = getImageColors(widget.vinyl.item.album.images.first.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double luminance = 0;
    return Scaffold(
      backgroundColor: const Color(0xFF241D1E),
      bottomNavigationBar: VinylBottomBar(
        vinylModel: widget.vinyl,
      ),
      body: SafeArea(
        child: FutureBuilder<PaletteGenerator>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                luminance =
                    computeLuminance(snapshot.data!.dominantColor!.color);
              } else {}
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1250),
                    // height: size.height * 0.45,
                    decoration: BoxDecoration(
                        // color: snapshot.connectionState ==
                        //             ConnectionState.done &&
                        //         snapshot.data != null
                        //     ? snapshot.data!.dominantColor!.color
                        //         .withOpacity(0.3)
                        //     : Theme.of(context).primaryColor.withOpacity(0.4)
                        ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SoulCircleAvatar(
                                    radius: 15,
                                    imageUrl: widget
                                        .vinyl.sender.profilePicture.image),
                                const SizedBox(
                                  width: defaultMargin,
                                ),
                                Text(
                                  widget.vinyl.sender.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultMargin),
                              child: SizedBox(
                                width: 30,
                                child: FittedBox(
                                  child: RowSuper(
                                      innerDistance: -10,
                                      children: widget.vinyl.audience
                                          .map((e) => SoulCircleAvatar(
                                              radius: 10,
                                              imageUrl: e.profilePicture.image))
                                          .toList()),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin),
                          child: Column(
                            children: [
                              Hero(
                                tag: widget.vinyl,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.vinyl.item.album.images.first.url,
                                  height: size.height * 0.23,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defaultMargin),
                                child: Column(
                                  children: [
                                    TextScroll(
                                      widget.vinyl.item.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 17),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: defaultPadding),
                                      child: TextScroll(
                                        widget.vinyl.item.artists.join(", "),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: 17),
                                      ),
                                    ),
                                    Text(widget.vinyl.item.album.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: 15))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultMargin),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SoulCircleAvatar(
                                    imageUrl: widget
                                        .vinyl.sender.profilePicture.image,
                                    radius: 15,
                                  ),
                                  const SizedBox(
                                    width: defaultMargin,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.vinyl.sender.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                      ),
                                      Text(
                                        widget.vinyl.caption ?? "No Caption",
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                widget.vinyl.date,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              Expanded(
                                child: VinylChatSection(
                                  vinyl: widget.vinyl,
                                  backgroundColor: snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data != null
                                      ? snapshot.data!.mutedColor != null
                                          ? snapshot.data!.mutedColor!.color
                                              .withOpacity(0.5)
                                          : snapshot.data!.dominantColor!.color
                                              .withOpacity(0.5)
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    defaultMargin,
                                    defaultMargin,
                                    defaultMargin,
                                    0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ChatTextField(
                                      // autoFocus: true,
                                      textColor: Colors.white,
                                      captionText: messageText,
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      key: inputKey,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(40, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            backgroundColor: snapshot
                                                            .connectionState ==
                                                        ConnectionState.done &&
                                                    snapshot.data != null
                                                ? snapshot
                                                    .data!.dominantColor!.color
                                                : Theme.of(context)
                                                    .primaryColor),
                                        onPressed: () {
                                          if (messageText.text.isNotEmpty) {
                                            VinylChat vinylChat = VinylChat(
                                                sender: soulController.profile!,
                                                message: messageText.text,
                                                dateSent: DateTime.now());
                                            FirebaseFirestore.instance
                                                .collection('sentTracks')
                                                .doc(widget.vinyl.id)
                                                .collection('messages')
                                                .add(vinylChat.toJson());

                                            messageText.clear();
                                          }
                                        },
                                        child: Icon(
                                          CupertinoIcons.paperplane_fill,
                                          color: luminance > 0.5
                                              ? Colors.black
                                              : Colors.white,
                                          size: 20,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
