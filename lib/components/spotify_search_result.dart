import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';
import 'package:soul_date/models/SpotifySearch/spotify_search.dart';

class SpotifyTrackResult extends StatefulWidget {
  const SpotifyTrackResult(
      {Key? key,
      required this.result,
      required this.onSelected,
      required this.onDeselect,
      this.disabled = false})
      : super(key: key);
  final Item result;
  final Function(Item item) onSelected;
  final Function(Item item) onDeselect;
  final bool disabled;

  @override
  State<SpotifyTrackResult> createState() => _SpotifyTrackResultState();
}

class _SpotifyTrackResultState extends State<SpotifyTrackResult>
    with AutomaticKeepAliveClientMixin {
  bool selected = false;
  final SoulController controller = Get.find<SoulController>();
  @override
  void initState() {
    if (controller.keyDb.containsValue(widget.result.id)) {
      selected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.result.album.images.first.url,
              width: 60,
              height: 60,
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
                    widget.result.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultMargin / 2),
                    child: Text(
                      widget.result.artists.join(", "),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
          Checkbox(
            value: selected,
            onChanged: (value) {
              if (!widget.disabled) {
                setState(() {
                  selected = value!;
                });

                selected
                    ? widget.onSelected(widget.result)
                    : widget.onDeselect(widget.result);
              } else if (selected) {
                setState(() {
                  selected = false;
                });
                widget.onDeselect(widget.result);
              }
            },
            activeColor: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
