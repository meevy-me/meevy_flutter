import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/spotify_favourite_item.dart';

class SpotifyTrackResult extends StatefulWidget {
  const SpotifyTrackResult({
    Key? key,
    required this.result,
    this.selected = false,
    this.disabled = false,
    required this.onClick,
  }) : super(key: key);
  final SpotifyFavouriteItem result;
  final Function(SpotifyFavouriteItem item) onClick;
  final bool disabled;
  final bool selected;

  @override
  State<SpotifyTrackResult> createState() => _SpotifyTrackResultState();
}

class _SpotifyTrackResultState extends State<SpotifyTrackResult>
    with AutomaticKeepAliveClientMixin {
  final SoulController controller = Get.find<SoulController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin),
      child: InkWell(
        onTap: () => widget.onClick(widget.result),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.result.imageUrl,
                width: widget.selected ? 70 : 60,
                height: widget.selected ? 70 : 60,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.result.title,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: widget.selected
                              ? Theme.of(context).primaryColor
                              : null),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin / 2),
                      child: Text(
                        widget.result.caption,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 14,
                            color: widget.selected
                                ? Theme.of(context).primaryColor
                                : null),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selected
                      ? Theme.of(context).primaryColor
                      : Colors.grey),
            )
            // Checkbox(
            //   value: selected,
            //   onChanged: (value) {
            //     if (!widget.disabled) {
            //       setState(() {
            //         selected = value!;
            //       });

            //       selected
            //           ? widget.onSelected(widget.result)
            //           : widget.onDeselect(widget.result);
            //     } else if (selected) {
            //       setState(() {
            //         selected = false;
            //       });
            //       widget.onDeselect(widget.result);
            //     }
            //   },
            //   activeColor: Theme.of(context).primaryColor,
            //   shape:
            //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            // )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
