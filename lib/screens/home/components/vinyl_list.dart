import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:soul_date/components/pulse.dart';
import 'package:soul_date/screens/home/components/vinyl_card.dart';
import 'package:soul_date/screens/home/models/vinyl_model.dart';

import '../../../constants/constants.dart';

class VinylList extends StatefulWidget {
  const VinylList({Key? key, required this.profileID}) : super(key: key);
  final int profileID;

  @override
  State<VinylList> createState() => _VinylListState();
}

class _VinylListState extends State<VinylList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultMargin),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              _TabLabel(
                text: "Received",
                color: _tabController.index == 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              _TabLabel(
                  text: "Sent",
                  color: _tabController.index == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey)
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildSentList(
                stream: FirebaseFirestore.instance
                    .collection('sentTracks')
                    .where("audience", arrayContains: [
                      {"id": widget.profileID}
                    ])
                    .orderBy('date_sent', descending: true)
                    .snapshots(),
              ),
              buildSentList(
                  mine: true,
                  stream: FirebaseFirestore.instance
                      .collection('sentTracks')
                      .where("sender.id", isEqualTo: widget.profileID)
                      .orderBy('date_sent', descending: true)
                      .snapshots())
            ],
          ),
        ),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: color),
      ),
    );
  }
}

StreamBuilder<QuerySnapshot<Object?>> buildSentList(
    {required Stream<QuerySnapshot> stream, bool mine = false}) {
  return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final userSnapshot = snapshot.data?.docs;
        return userSnapshot != null && userSnapshot.isNotEmpty
            ? ListView.separated(
                padding: scaffoldPadding,
                itemCount: userSnapshot != null ? userSnapshot.length : 0,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey.withOpacity(0.2),
                  );
                },
                itemBuilder: (context, index) {
                  var doc = userSnapshot[index];
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return VinylSentCard(
                      mine: mine, vinyl: VinylModel.fromJson(data, doc.id));
                },
              )
            : Center(
                child: Text(
                "Its Lonely in here",
                style: Theme.of(context).textTheme.caption,
              ));
      });
}
