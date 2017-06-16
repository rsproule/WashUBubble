import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';

class EventTile extends StatefulWidget {
  DataSnapshot snapshot;
  Animation animation;

  EventTile({this.animation, this.snapshot});

  @override
  _EventTileState createState() =>
      new _EventTileState(animation, snapshot);
}

class _EventTileState extends State<EventTile> {
  DataSnapshot snapshot;
  Animation animation;

  _EventTileState(Animation a, DataSnapshot s) {
    this.animation = a;
    this.snapshot = s;
    _loadImage();
  }

  Image image;


  @override
  Widget build(BuildContext context) {
    String eventDateReadable = _convertDateStringToReadable(
        snapshot.value['date']);
    DateTime timeOfStartOfEvent = _convertTimeInfoToDateTimeObj(
        snapshot.value['date'], snapshot.value['start_time']);
    DateTime timeOfEndOfEvent = _convertTimeInfoToDateTimeObj(
        snapshot.value['date'], snapshot.value['end_time']);
    DateTime now = new DateTime.now();

    int timeTillEvent = timeOfStartOfEvent
        .difference(now)
        .inMinutes;

    int timeTillEventIsOver = timeOfEndOfEvent
        .difference(now)
        .inMinutes;


    if (timeTillEventIsOver > 0) {
      return new Card(
          child: new Column(
              children: <Widget>[
                new Row(
                    children: <Widget>[
                      new Column(children: <Widget>[
                        new IconButton(
                            icon: new Icon(Icons.star),
                            onPressed: _addToStarred),
                        new Text("13"), // TODO show the
                        // number of people that
                        // have starred this
                      ]
                      ),
                      new Expanded(
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: new Text(
                                    snapshot.value['name'], style: Theme
                                    .of(context)
                                    .textTheme
                                    .title),
                              ),
                              new Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: new Text(
                                    snapshot.value['group_name'], style: Theme
                                    .of(context)
                                    .textTheme
                                    .subhead),
                              ),
                            ]
                        ),
                      ),


                      new Expanded(
                        child: new Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          alignment: FractionalOffset.topRight,
                          child: new Column(
                              children: <Widget>[
                                new Text(eventDateReadable),
                                timeTillEvent < 60 && timeTillEvent > 0
                                //only show the countdown when within the hour
                                    ? new Text(
                                    "Starts in " + timeTillEvent.toString() +
                                        " minutes",
                                    style: new TextStyle(color: Colors.red))
                                    : new Text(" "),


                                timeTillEventIsOver > 0 && timeTillEvent < 0
                                    ? new Text("Ongoing",
                                    style: new TextStyle(
                                        color: Colors.green, fontSize: 18.0))
                                    : new Text("")
                              ]
                          ),

                        ),
                      )


                    ]
                ),

                new Container(
                  //todo needs to cache in the parent widget
                    padding: const EdgeInsets.all(4.0),
                    child:
                    new Container(
//                        decoration: new BoxDecoration(
//                            border: new Border.all(
//                                color: Colors.grey, width: 1.0)
//                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7.0),


                        child: snapshot.value['image_url'] == null
                            ? new Image.network(
                          "http://edmhousenetwork.net/upload/gates/default.jpg",
                          height: 380.0,
                          width: 400.0,
                        ) : new Image.network(
                          snapshot.value['image_url'],
                          height: 380.0,
                          width: 400.0,
                        )
//                        this.image != null
//                            ? this.image
//                            : new Container(
//
//                            width: 400.0,
//                            height: 380.0,
//                            child: new Center(
//                                child: new CircularProgressIndicator()
//                            )
//                        )
                    )
                ),
                new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                  children: <Widget>[
                                    new Icon(Icons.location_on),
                                    new Text(" " + snapshot.value['location']),
                                  ]
                              ),
                              new Divider(color: Colors.transparent),
                              new Row(
                                  children: <Widget>[
                                    new Icon(Icons.timer),
                                    new Text(" " +
                                        snapshot.value['start_time'] + " - " +
                                        snapshot.value['end_time']),
                                  ]
                              ),
                              new Divider(color: Colors.transparent)

                            ]
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                  children: <Widget>[
                                    new Icon(Icons.fastfood),
                                    new Text(" " + snapshot.value['food_type']),
                                  ]
                              ),
                              new Divider(color: Colors.transparent),
                              new Row(
                                  children: <Widget>[
                                    new Icon(Icons.fastfood,
                                        color: Colors.transparent),
                                    new Text(" "),
                                  ]
                              ),
                              new Divider(color: Colors.transparent)

                            ]
                        ),
                      ),


                    ]
                ),
                new Row(
                    children: <Widget>[
                      new Icon(Icons.info_outline),
                      new Expanded(child:
                      new Container(padding: const EdgeInsets.only(left: 4.0),
                          child: new Text(
                              snapshot.value['description']))
                      )

                    ]
                ),
                new Divider(color: Colors.transparent),


              ]
          )
      );
    } else {
      return new Container();
    }
  }


  String _convertDateStringToReadable(String s) {
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
  _convertTimeInfoToDateTimeObj(String rawDate, String startTime) {
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


  void _addToStarred() {
    //Todo update the starred

  }

  Future<Image> _getImage() async {
//    return new Image.memory(await http.readBytes("https://wallpaperbrowse.com/media/images/8DJWnR85.jpg")) ;
//
    return new Image.network(
      "https://wallpaperbrowse.com/media/images/8DJWnR85.jpg",
      height: 380.0,
      width: 400.0,
    );
  }

  _loadImage() async {
    _getImage().then((img) => _handleImage(img)

    ).catchError((err) => _errorLoadingImage(err));
  }

  _handleImage(Image img) {
//    print(img);
    if (img == null) {
      _errorLoadingImage();
    }

    if (this.mounted) {
      setState(() {
        image = img;
      });
    }
  }


  _errorLoadingImage([err]) {
    print(err);
    if (this.mounted) {
      setState(() {
        //error image
        image = new Image.network(
            "https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2015/12/1450973046wordpress-errors.png");
      });
    }
  }


}
