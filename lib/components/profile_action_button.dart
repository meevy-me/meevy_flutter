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
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final Function onTap;
  final String subtitle;
  final Color? color;

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
                Container(
                  padding: const EdgeInsets.all(defaultMargin),
                  decoration: BoxDecoration(
                      color: color ?? Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    iconData,
                    size: 25,
                    color: Colors.white,
                  ),
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
                      child: Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(overflow: TextOverflow.ellipsis),
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
