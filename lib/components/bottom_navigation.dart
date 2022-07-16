import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soul_date/constants/constants.dart';

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
      margin: const EdgeInsets.fromLTRB(
          defaultMargin * 3, 0, defaultMargin * 3, defaultMargin),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedIndex = 0;
                widget.onTap(0);
              });
            },
            child: _BottomNavigationItem(
              active: selectedIndex == 0 ? true : false,
              iconData: FontAwesomeIcons.house,
            ),
          ),
          InkWell(
            onTap: () => setState(() {
              selectedIndex = 1;
              widget.onTap(1);
            }),
            child: _BottomNavigationItem(
              active: selectedIndex == 1 ? true : false,
              iconData: FontAwesomeIcons.userLarge,
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
    required this.iconData,
    this.active = false,
  }) : super(key: key);

  final bool active;
  final IconData iconData;

  @override
  State<_BottomNavigationItem> createState() => _BottomNavigationItemState();
}

class _BottomNavigationItemState extends State<_BottomNavigationItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      width: widget.active ? size.width / 2 : (size.width / 2.83),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          color: widget.active ? Colors.white : null,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Icon(
          widget.iconData,
          size: 20,
          color: widget.active ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
