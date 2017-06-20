import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../AcademicStuff/loginStuff.dart' as login;
import './EventTile.dart' as event;

class StarredEventsPage extends StatefulWidget {
  @override
  _StarredEventsPageState createState() => new _StarredEventsPageState();
}

class _StarredEventsPageState extends State<StarredEventsPage> {
  DatabaseReference ref = FirebaseDatabase.instance.reference().child("stars");

  GoogleSignIn user;


  _StarredEventsPageState() {
    user = login.getUser();
    ref = ref.child(user.currentUser.id);
  }

  Comparator byTime = (a, b) {
    DateTime aDate = DateTime.parse(a.value['date']);
    DateTime bDate = DateTime.parse(b.value['date']);

    return aDate.millisecondsSinceEpoch - bDate.millisecondsSinceEpoch;
  };


  @override
  Widget build(BuildContext context) {
    return new FirebaseAnimatedList(
        query: ref,
        sort: byTime,
        itemBuilder: (context, DataSnapshot snapshot,
            Animation<double> animation) {
          return new event.EventTile(
              animation: animation,
              snapshot: snapshot,
              isStarredPage: true
          );
        }
    );
  }
}