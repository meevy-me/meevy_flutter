import 'package:flutter/material.dart';
import 'package:soul_date/components/image_circle.dart';
import 'package:soul_date/constants/constants.dart';

class NoticeService {
  static Widget soulNotice(Map<String, dynamic> data) {
    data['images'] as List;
    return AlertDialog(
      insetPadding: const EdgeInsets.all(defaultMargin),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        padding: scaffoldPadding,
        decoration: BoxDecoration(
            color: const Color(0xffFc9c9f),
            borderRadius: BorderRadius.circular(20)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Image.asset(
                'assets/images/notice_soul.png',
                width: 150,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text("You have met a new soul",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ...data['images']
                      .take(4)
                      .map((e) => SoulCircleAvatar(
                            imageUrl: e['image'],
                            radius: 16,
                          ))
                      .toList(),
                ]),
                const SizedBox(
                  height: defaultMargin,
                ),
                Text(
                  data['name'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
