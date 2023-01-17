import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_extend/share_extend.dart';
import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/constants/constants.dart';
import 'package:soul_date/controllers/SoulController.dart';

class InviteModal extends StatefulWidget {
  const InviteModal({Key? key}) : super(key: key);

  @override
  State<InviteModal> createState() => _InviteModalState();
}

class _InviteModalState extends State<InviteModal> {
  final SoulController controller = Get.find<SoulController>();
  String? msg;
  @override
  void initState() {
    String profileID = controller.profile!.user.spotifyId;
    String url = "https://meevy.me/app/invite/$profileID";
    setState(() {
      msg = "Hey, Be my music buddy,\n$url";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.4),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
      child: Padding(
        padding: scaffoldPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Invite your friends",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.white),
            ),
            msg != null
                ? Column(
                    children: [
                      _InviteAction(
                        icon: FontAwesomeIcons.whatsapp,
                        text: "Whatsapp",
                        color: whatsappColor,
                        onTap: () {
                          if (msg != null) {
                            FlutterShareMe().shareToWhatsApp(msg: msg!);
                          }
                        },
                      ),
                      _InviteAction(
                        icon: FontAwesomeIcons.twitter,
                        text: "Twitter",
                        color: twitterColor,
                        onTap: () {
                          if (msg != null) {
                            FlutterShareMe().shareToTwitter(msg: msg!);
                          }
                        },
                      ),
                      _InviteAction(
                        icon: FontAwesomeIcons.facebook,
                        text: "Facebook",
                        color: facebookColor,
                        onTap: () {
                          if (msg != null) {
                            FlutterShareMe().shareToFacebook(msg: msg!);
                          }
                        },
                      ),
                      _InviteAction(
                        icon: Icons.more_horiz,
                        color: Colors.grey,
                        text: "More",
                        onTap: () {
                          if (msg != null) {
                            ShareExtend.share(msg!, "text");
                          }
                        },
                      ),
                    ],
                  )
                : const Center(
                    child: LoadingPulse(),
                  )
          ],
        ),
      ),
    );
  }
}

class _InviteAction extends StatelessWidget {
  const _InviteAction({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
    this.color,
  }) : super(key: key);
  final IconData icon;
  final Color? color;
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultMargin * 2),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(
              width: defaultMargin,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
