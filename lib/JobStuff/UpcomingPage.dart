import 'package:flutter/material.dart';


// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import './EventTile.dart' as event;

class UpcomingPage extends StatefulWidget {
  @override
  _UpcomingPageState createState() => new _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  DatabaseReference events = FirebaseDatabase.instance.reference().child(
      "foodEvents");

  Comparator byTime = (a, b) {
    DateTime aDate = DateTime.parse(a.value['date']);
    DateTime bDate = DateTime.parse(b.value['date']);

    return aDate.millisecondsSinceEpoch - bDate.millisecondsSinceEpoch;
  };

  @override
  Widget build(BuildContext context) {
    return

      new FirebaseAnimatedList(
          query: events,
          defaultChild: new Center(child: new CircularProgressIndicator()),
          sort: byTime,
          itemBuilder: (context, DataSnapshot snapshot,
              Animation<double> animation) {
            return new event.
            EventTile(
                animation: animation, snapshot: snapshot, isStarredPage: false);
          }
      );
  }
}
