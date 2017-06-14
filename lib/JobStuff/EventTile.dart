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
    String eventDateReadable = _convertDateStringReadable(
        snapshot.value['date']);
    DateTime timeOfStartOfEvent = _convertTimeInfo(
        snapshot.value['date'], snapshot.value['start_time']);
    DateTime timeOfEndOfEvent = _convertTimeInfo(
        snapshot.value['date'], snapshot.value['end_time']);
    DateTime now = new DateTime.now();

    int timeTillEvent = timeOfStartOfEvent
        .difference(now)
        .inMinutes;


    if (now
        .difference(timeOfEndOfEvent)
        .inMinutes < 0) {
      return new Card(
          child: new Column(
              children: <Widget>[
                new Text(snapshot.value['name']),
                new Text(snapshot.value['group_name']),
                new Text(snapshot.value['location']),
                new Text(eventDateReadable),
                new Text(snapshot.value['description']),
                new Text(snapshot.value['food_type']),
//                timeTillEvent < 60
                //     ?
                new Text("Time till event starts: " + timeTillEvent.toString() +
                    " minutes"),
                //   : new Container(),

                new Text(snapshot.value['start_time'] + " - " +
                    snapshot.value['end_time']),

              ]
          )
      );
    } else {
      return new Container();
    }
  }


  String _convertDateStringReadable(String s) {
    DateTime d = DateTime.parse(s);
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[d.month - 1] + " " + d.day.toString() + ", " +
        d.year.toString();
  }

  /// raw date can be easily converted to DateTime using parse
  /// start time is a formatted string ie 4:00 p.m.
  _convertTimeInfo(String rawDate, String startTime) {
    DateTime date = DateTime.parse(rawDate);
    List<String> splitS = startTime.split(':');
    int hour = int.parse(splitS[0]);
    ;
    if (startTime.endsWith("p.m.")) {
      hour += 12;
    }

    int minute = int.parse(splitS[1].split(' ')[0]);

    DateTime dateTime = new DateTime(
        date.year, date.month, date.day, hour, minute);

    return dateTime;
  }

}
