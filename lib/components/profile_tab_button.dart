import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';

class ProfileTabButton extends StatelessWidget {
  const ProfileTabButton({
    Key? key,
    required this.active,
    required this.text,
    required this.icon,
    required this.activeIcon,
    required this.color,
  }) : super(key: key);
  final bool active;
  final String text;
  final Widget icon;
  final Widget activeIcon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.symmetric(
          horizontal: defaultMargin * 2, vertical: defaultMargin),
      decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Row(
          children: [
            active ? activeIcon : icon,
            const SizedBox(
              width: defaultMargin,
            ),
            Text(text,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: active ? color : defaultGrey))
          ],
        ),
      ),
    );
  }
}
