import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soul_date/constants/spacings.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/screens/image_viewer.dart';

class MyImages extends StatefulWidget {
  const MyImages({
    Key? key,
  }) : super(key: key);

  @override
  State<MyImages> createState() => _MyImagesState();
}

class _MyImagesState extends State<MyImages> {
  final SoulController controller = Get.find<SoulController>();
  XFile? _file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            "My Images",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: scaffoldPadding,
            child: SingleChildScrollView(
              child: Obx(
                () => Wrap(
                  // runAlignment: WrapAlignment.spaceBetween,
                  // alignment: WrapAlignment.spaceBetween,
                  spacing: defaultMargin,
                  runSpacing: defaultMargin,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        _file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (_file != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageView(
                                        fileUploaded: _file,
                                      )));
                        }
                      },
                      child: Container(
                        height: 120,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(FontAwesomeIcons.fileCirclePlus),
                      ),
                    ),
                    ...controller.profile.first.images.map((e) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ImageView(
                                        imageUrl: e.image, imageID: e.id))));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: e.image,
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
