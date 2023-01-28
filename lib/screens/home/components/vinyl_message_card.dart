import 'package:flutter/material.dart';
import 'package:soul_date/screens/home/models/chat_model.dart';

import '../../../components/image_circle.dart';
import '../../../constants/constants.dart';

class VinylMessageCard extends StatelessWidget {
  const VinylMessageCard({
    Key? key,
    this.mine = false,
    required this.vinyl,
    required this.color,
    this.textColor,
  }) : super(key: key);

  final VinylChat vinyl;
  final Color color;
  final bool mine;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    // double luminance = computeLuminance(color);
    Size size = MediaQuery.of(context).size;
    return vinyl.message.isNotEmpty
        ? SizedBox(
            child: Row(
              mainAxisAlignment:
                  mine ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !mine
                    ? Row(
                        children: [
                          SoulCircleAvatar(
                            imageUrl: vinyl.sender.profilePicture.image,
                            radius: 13,
                          ),
                          const SizedBox(
                            width: defaultMargin,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: mine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            mine ? "You" : vinyl.sender.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: defaultMargin,
                          ),
                          Text(
                            vinyl.date,
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Align(
                        alignment:
                            mine ? Alignment.topRight : Alignment.topLeft,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultMargin,
                              horizontal: defaultMargin),
                          width: size.width * 0.6,
                          decoration: BoxDecoration(
                              color:
                                  mine ? color : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            vinyl.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: textColor ?? Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
