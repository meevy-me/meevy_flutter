import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoulBottomNavigationBar extends StatefulWidget {
  const SoulBottomNavigationBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function(int index) onTap;
  @override
  State<SoulBottomNavigationBar> createState() =>
      _SoulBottomNavigationBarState();
}

class _SoulBottomNavigationBarState extends State<SoulBottomNavigationBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 55,
      width: size.width,
      // margin: const EdgeInsets.fromLTRB(
      //     defaultMargin * 3, 0, defaultMargin * 3, defaultMargin),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  widget.onTap(0);
                });
              },
              child: _BottomNavigationItem(
                active: selectedIndex == 0 ? true : false,
                icon: CupertinoIcons.house_alt_fill,
                title: "Home",
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  widget.onTap(1);
                });
              },
              child: _BottomNavigationItem(
                active: selectedIndex == 1 ? true : false,
                child: SvgPicture.asset(
                  'assets/images/paper.svg',
                  height: selectedIndex == 1 ? 28 : 25,
                  color: selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                title: "Messages",
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                  widget.onTap(2);
                });
              },
              child: _BottomNavigationItem(
                active: selectedIndex == 2 ? true : false,
                child: SvgPicture.asset(
                  'assets/images/disco.svg',
                  height: selectedIndex == 2 ? 26 : 23,
                  color: selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                title: "Discover",
              ),
            ),
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
  }) : super(key: key);

  final bool active;
  final IconData? icon;
  final String title;
  final Widget? child;

  @override
  State<_BottomNavigationItem> createState() => _BottomNavigationItemState();
}

class _BottomNavigationItemState extends State<_BottomNavigationItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
            color: widget.active ? Colors.white : null,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.child ??
                  Icon(
                    widget.icon,
                    size: widget.active ? 28 : 25,
                    color: widget.active ? Colors.black : Colors.grey,
                  ),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: widget.active
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    fontWeight: widget.active ? FontWeight.w600 : null),
              )
            ],
          ),
        ));
  }
}
