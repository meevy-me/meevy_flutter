import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';

import 'package:soul_date/models/profile_model.dart';
import 'package:soul_date/models/spotify_spot_details.dart' as Spot;

import 'components/spot_background.dart';
import 'components/spot_song_image.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen(
      {Key? key, required this.item, required this.profile, this.caption})
      : super(key: key);
  final Spot.Item item;
  final Profile profile;
  final String? caption;

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final GlobalKey spotKey = GlobalKey();
  // final SoulController controller = Get.find<SoulController>();
  // final SpotController spotController = Get.find<SpotController>();

  Future<Uint8List> captureWidget() async {
    final RenderRepaintBoundary boundary =
        spotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 5);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }

  Future<String> bytesToPath(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(bytes);
    return file.path;
  }

  Future<String> getImagePath() async {
    return await bytesToPath(await captureWidget());
  }

  Future<String> exportSpot() async {
    Uint8List bytes = await captureWidget();
    return await bytesToPath(bytes);
  }

  Future<Map<String, dynamic>> shareContent() async {
    return {
      "message":
          "I'm listening to ${widget.item.name} by ${widget.item.artists.join(', ')} \n ${widget.item.externalUrls.spotify}",
      "imagePath": await getImagePath()
    };
  }

  void shareOthers(BuildContext context, String path) {
    final box = context.findRenderObject() as RenderBox?;

    ShareExtend.share(path, "image",
        subject: widget.item.name,
        extraText:
            "I'm listening to ${widget.item.name} by ${widget.item.artists.join(', ')} \n ${widget.item.externalUrls.spotify}",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
  //Implement Dispose

  // Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RepaintBoundary(
              key: spotKey,
              child: SpotWidget(
                item: widget.item,
                caption: widget.caption,
                profile: widget.profile,
              ),
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Share To",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            var data = await shareContent();
                            FlutterShareMe().shareToTwitter(
                                msg: data['message'], url: data['imagePath']);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.twitter,
                            color: twitterColor,
                          )),
                      IconButton(
                          onPressed: () async {
                            var data = await shareContent();
                            FlutterShareMe().shareToFacebook(
                                msg: data['message'], url: data['imagePath']);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.facebook,
                            color: facebookColor,
                          )),
                      IconButton(
                          onPressed: () async {
                            var data = await shareContent();
                            FlutterShareMe()
                                .shareToInstagram(filePath: data['imagePath']);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: instagramColor,
                          )),
                      IconButton(
                          onPressed: () async {
                            var data = await shareContent();
                            FlutterShareMe().shareToWhatsApp(
                                msg: data['message'],
                                imagePath: data['imagePath']);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: whatsappColor,
                          )),
                      IconButton(
                          onPressed: () async {
                            var data = await shareContent();
                            shareOthers(context, data['imagePath']);
                          },
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SpotWidget extends StatelessWidget {
  const SpotWidget({
    Key? key,
    required this.item,
    required this.profile,
    this.caption,
  }) : super(key: key);

  final Spot.Item item;
  final Profile profile;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      SpotScreenBackground(
        item: item,
      ),
      SafeArea(
        child: SizedBox(
          height: size.height * 0.8,
          child: Padding(
            padding: scaffoldPadding,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: defaultMargin),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo-text.png',
                          width: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              profile.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              width: defaultMargin,
                            ),
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              child: SoulCircleAvatar(
                                imageUrl: profile.profilePicture.image,
                                radius: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Center(
        child: SongWithImage(
          caption: caption,
          item: item,
        ),
      )
    ]);
  }
}
