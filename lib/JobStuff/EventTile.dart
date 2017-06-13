import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class EventTile extends StatefulWidget {
  DataSnapshot snapshot;
  Animation animation;

  EventTile({this.animation, this.snapshot});

  @override
  _EventTileState createState() =>
      new _EventTileState(animation: animation, snapshot: snapshot);
}

class _EventTileState extends State<EventTile> {
  DataSnapshot snapshot;
  Animation animation;

  _EventTileState({this.animation, this.snapshot});

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
