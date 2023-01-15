import 'package:flutter/material.dart';
import 'package:soul_date/constants/constants.dart';

class ProfileActionButton extends StatelessWidget {
  const ProfileActionButton({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.subtitle,
    this.color,
    this.child1,
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final Function onTap;
  final String subtitle;
  final Color? color;
  final Widget? child1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
          child: InkWell(
            onTap: () => onTap(),
            child: Row(
              children: [
                Icon(
                  iconData,
                  size: 27,
                  color: color ?? Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: defaultMargin * 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 15),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Row(
                        children: [
                          child1 != null ? child1! : const SizedBox.shrink(),
                          SizedBox(
                            width: child1 != null ? defaultPadding : 0,
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 25,
                )
              ],
            ),
          ),
        ),
        // const Divider()
      ],
    );
  }
}
