import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _file = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (_file != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            fileUploaded: _file,
                          )));
            }
          },
          child: const Icon(
            FontAwesomeIcons.fileCirclePlus,
            size: 20,
          )),
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
            child: GetBuilder<SoulController>(
                id: 'profile',
                builder: (controller) {
                  return GridView.custom(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverWovenGridDelegate.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      pattern: [
                        const WovenGridTile(1),
                        const WovenGridTile(
                          5 / 7,
                          crossAxisRatio: 0.9,
                          alignment: AlignmentDirectional.centerEnd,
                        ),
                      ],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            imageUrl: controller.profile!
                                                .validImages[index].image)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                      .profile!.validImages[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        childCount: controller.profile!.validImages.length),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
