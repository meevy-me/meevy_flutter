import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/screens/home/vinyls.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../constants/constants.dart';

class ReceivedSongsList extends StatelessWidget {
  const ReceivedSongsList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Vinyls",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    "Check out what your friends sent you",
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              const Spacer(),
              Text(
                "View All",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).primaryColor),
              )
            ],
          ),
          ListView.builder(
            primary: false,
            itemBuilder: (context, index) {
              return _ReceivedSongCard(index: index);
            },
            itemCount: 2,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}

class _ReceivedSongCard extends StatelessWidget {
  const _ReceivedSongCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Radius radius = const Radius.circular(20);
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VinylsPage()));
      },
      child: Container(
          height: 120,
          width: size.width,
          padding: const EdgeInsets.symmetric(
              horizontal: defaultMargin, vertical: defaultPadding),
          margin: EdgeInsets.only(
              top: defaultMargin * 2,
              right: index.isEven ? defaultMargin : 0.0,
              left: index.isOdd ? defaultMargin : 0.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.all(radius)),
          child: Row(
            children: [
              const SoulCircleAvatar(
                imageUrl: defaultGirlUrl,
                radius: 22,
              ),
              const SizedBox(
                width: defaultMargin,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultMargin),
                        child: RowSuper(children: const [
                          SoulCircleAvatar(
                            imageUrl: secondaryAvatarUrl,
                            radius: 12,
                          )
                        ]),
                      ),
                    ),
                    Text(
                      "Hope Celestine",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: defaultMargin / 2),
                      child: Row(
                        children: [
                          const SoulCircleAvatar(
                            imageUrl: defaultArtistUrl,
                            radius: 12,
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          TextScroll(
                            "Perfect. Ed Sheeran",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: spotifyGreen),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      children: [
                        Text(
                          "Hope:",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Expanded(
                          child: Text(
                            "Omg Guys you need to listen to this",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
