import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _SettingsBody()),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  _SettingsBody({Key? key}) : super(key: key);
  final SoulController controller = Get.find<SoulController>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: scrollPadding,
      children: [
        InkWell(
          onTap: () {
            controller.logout();
          },
          child: Row(
            children: const [
              Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              SizedBox(
                width: defaultMargin,
              ),
              Text("Logout")
            ],
          ),
        )
      ],
    );
  }
}
