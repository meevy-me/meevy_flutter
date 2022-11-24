import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef ReorderableWidgetBuilder = Widget Function(
    BuildContext context, int index, DocumentSnapshot doc);

class ReorderableFirebaseList extends StatefulWidget {
  const ReorderableFirebaseList({
    Key? key,
    required this.collection,
    required this.indexKey,
    required this.itemBuilder,
    this.descending = false,
  }) : super(key: key);

  final CollectionReference collection;
  final String indexKey;
  final bool descending;
  final ReorderableWidgetBuilder itemBuilder;

  @override
  _ReorderableFirebaseListState createState() =>
      _ReorderableFirebaseListState();
}

class _ReorderableFirebaseListState extends State<ReorderableFirebaseList> {
  List<DocumentSnapshot>? _docs;
  Future? _saving;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _saving,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: widget.collection
                .orderBy(widget.indexKey, descending: widget.descending)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _docs = snapshot.data!.docs;
                return ReorderableListView(
                  onReorder: _onReorder,
                  children: List.generate(_docs!.length, (int index) {
                    return widget.itemBuilder(context, index, _docs![index]);
                  }),
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "Updating your chats",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    _docs!.insert(newIndex, _docs!.removeAt(oldIndex));
    final futures = <Future>[];
    for (int pos = 0; pos < _docs!.length; pos++) {
      futures.add(_docs![pos].reference.update({widget.indexKey: pos}));
    }
    setState(() {
      _saving = Future.wait(futures);
    });
  }
}
