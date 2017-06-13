import 'package:flutter/material.dart';
import '../AcademicStuff/loginStuff.dart' as login;
import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class UpcomingPage extends StatefulWidget {
  @override
  _UpcomingPageState createState() => new _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  DatabaseReference events = FirebaseDatabase.instance.reference().child(
      "foodEvents");

  @override
  Widget build(BuildContext context) {
    return new FirebaseAnimatedList(
        query: events,
        defaultChild: new Text("Loading..."),
        itemBuilder: (context, DataSnapshot snapshot,
            Animation<double> animation) {
          return new Text(snapshot.value['name']);
        }

    );
  }
}
