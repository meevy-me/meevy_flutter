import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class SoulBottomNavigationBar extends StatefulWidget {
  const SoulBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.activeIndex,
  }) : super(key: key);

  final Function(int index) onTap;
  final int activeIndex;

  @override
  State<SoulBottomNavigationBar> createState() =>
      _SoulBottomNavigationBarState();
}

class _SoulBottomNavigationBarState extends State<SoulBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 55,
      width: size.width,
      // margin: const EdgeInsets.fromLTRB(
      //     defaultMargin * 3, 0, defaultMargin * 3, defaultMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                // selectedIndex = 0;
                widget.onTap(0);
              });
            },
            child: _BottomNavigationItem(
              active: widget.activeIndex == 0 ? true : false,
              assetUrl: 'assets/images/home.svg',
              title: "Home",
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTap(1);
              });
            },
            child: _BottomNavigationItem(
              active: widget.activeIndex == 1 ? true : false,
              assetUrl: 'assets/images/users-alt.svg',
              title: "Friends",
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTap(2);
              });
            },
            child: _BottomNavigationItem(
              active: widget.activeIndex == 2 ? true : false,
              assetUrl: 'assets/images/map-marker-three.svg',
              title: "Map",
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.onTap(3);
              });
            },
            child: GetBuilder<SoulController>(
                // tag: 'profile',
                builder: (controller) {
              return _BottomNavigationItem(
                active: widget.activeIndex == 3 ? true : false,
                child: controller.profile != null
                    ? SoulCircleAvatar(
                        imageUrl: controller.profile!.profilePicture.image,
                        radius: 12,
                      )
                    : null,
                assetUrl: 'assets/images/user.svg',
                title: "Profile",
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationItem extends StatefulWidget {
  const _BottomNavigationItem({
    Key? key,
    this.active = false,
    this.icon,
    required this.title,
    this.child,
    this.assetUrl,
  }) : super(key: key);

  final bool active;
  final IconData? icon;
  final String title;
  final Widget? child;
  final String? assetUrl;

  @override
  State<_BottomNavigationItem> createState() => _BottomNavigationItemState();
}

class _BottomNavigationItemState extends State<_BottomNavigationItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.child != null) widget.child!,
          if (widget.child == null)
            widget.assetUrl != null
                ? SvgPicture.asset(
                    widget.assetUrl!,
                    color: widget.active
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: 18,
                  )
                : Icon(
                    widget.icon,
                    size: widget.active ? 22 : 20,
                    color: widget.active ? Colors.black : Colors.grey,
                  ),
          const SizedBox(
            width: defaultPadding,
          ),
          widget.active
              ? Text(
                  widget.title,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: widget.active
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      fontWeight: widget.active ? FontWeight.w600 : null),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
