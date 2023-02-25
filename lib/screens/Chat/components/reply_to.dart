import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soul_date/components/image_circle.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';

class ReplyTo extends StatelessWidget {
  const ReplyTo({
    Key? key,
    required this.message,
    this.onDismiss,
    this.textColor,
    this.width = 200,
  }) : super(key: key);
  final Message message;
  final Color? textColor;
  final double width;
  final void Function()? onDismiss;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultMargin, vertical: defaultPadding),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.reply,
            color: Colors.grey,
            size: 18,
          ),
          SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: message.spotifyData == null
                  ? Text(
                      message.content,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: textColor ?? Colors.white),
                    )
                  : Row(
                      children: [
                        SoulCircleAvatar(
                          imageUrl: message.spotifyData!.image,
                          radius: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Text(
                            message.spotifyData!.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
            child: GestureDetector(
                onTap: onDismiss,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                )),
          )
        ],
      ),
    );
  }
}
