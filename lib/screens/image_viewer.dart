import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:soul_date/components/buttons.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class ImageView extends StatelessWidget {
  ImageView({
    Key? key,
    this.fileUploaded,
    this.imageUrl,
    this.imageID,
  }) : super(key: key);
  final XFile? fileUploaded;
  final String? imageUrl;
  final int? imageID;
  final SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: LoadingPulse(color: Theme.of(context).primaryColor),
        ),
        child: Padding(
          padding: scaffoldPadding,
          child: Column(
            children: [
              SizedBox(
                  height: size.height * 0.9,
                  child: fileUploaded != null
                      ? Center(
                          child: Image.file(
                          File(fileUploaded!.path),
                          fit: BoxFit.cover,
                        ))
                      : Center(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )),
              if (fileUploaded != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      PrimaryButton(
                          onPress: () {
                            controller.uploadImage(fileUploaded!,
                                context: context);
                          },
                          text: "Upload")
                    ],
                  ),
                )
              else
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      if (imageID != null)
                        PrimaryButton(
                            onPress: () {
                              controller.deleteImage(imageID!,
                                  context: context);
                            },
                            text: "Delete")
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
