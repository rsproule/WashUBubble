import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage extends StatelessWidget {
  Map data;
  File image;

  PreviewPage(this.data, this.image);

  @override
  Widget build(BuildContext context) {
    String eventDateReadable = _convertDateStringToReadable(
        data['date']);
    DateTime timeOfStartOfEvent = _convertTimeInfoToDateTimeObj(
        data['date'], data['start_time']);
    DateTime timeOfEndOfEvent = _convertTimeInfoToDateTimeObj(
        data['date'], data['end_time']);
    DateTime now = new DateTime.now();

    int timeTillEvent = timeOfStartOfEvent
        .difference(now)
        .inMinutes;

    int timeTillEventIsOver = timeOfEndOfEvent
        .difference(now)
        .inMinutes;


    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Preview"),
        ),
        body: new Column(
          children: <Widget>[
            new Card(
                child: new Column(
                    children: <Widget>[
                      new Row(
                          children: <Widget>[


                            new Column(children: <Widget>[
                              new IconButton(
                                  icon: new Icon(
                                      Icons.star),
                                  onPressed: null
                              )
                            ]
                            ),
                            new Expanded(
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0),
                                      child: new Text(
                                          data['name'], style: Theme
                                          .of(context)
                                          .textTheme
                                          .title),
                                    ),
                                    new Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0),
                                      child: new Text(
                                        data['group_name'], style: Theme
                                          .of(context)
                                          .textTheme
                                          .subhead,),
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
                                      new
                                      Text(eventDateReadable),
                                      timeTillEvent < 60 && timeTillEvent > 0
//only show the countdown when within the hour
                                          ? new Text(
                                          "Starts in " +
                                              timeTillEvent.toString() +
                                              " minutes",
                                          style: new TextStyle(
                                              color: Colors.red))
                                          : new Text(" "),


                                      timeTillEventIsOver > 0 &&
                                          timeTillEvent < 0
                                          ? new Text("Ongoing",
                                          style: new TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0))
                                          : new Text("")
                                    ]
                                ),

                              ),
                            )


                          ]
                      ),

                      new Container
                        (
//todo needs to cache in the parent widget
                          padding: const EdgeInsets.all(4.0),
                          child:
                          new Container(
                              decoration: new BoxDecoration(
//                            border: new Border.all(
//                                color: Colors.grey, width: 1.0)
                                color: new Color.fromRGBO(226, 226, 226, 1.0),
                              ),
//                        padding: const EdgeInsets.symmetric(vertical: 7.0),


                              child: new Image.file(this.image)
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
                                          new Icon(
                                              Icons.location_on),
                                          new Text(" " + data['location']),
                                        ]
                                    ),
                                    new Divider(color: Colors.transparent),
                                    new Row(
                                        children: <Widget>[
                                          new Icon(Icons.timer),
                                          new Text(" " +
                                              data['start_time'] + " - " +
                                              data['end_time']),
                                        ]
                                    ),
                                    new Divider(color: Colors.transparent)

                                  ]
                              ),
                            ),
                            new Expanded(
                              child: new Column
                                (
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Row(
                                        children: <Widget>[
                                          new Icon(Icons.fastfood),
                                          new Text(" " + data['food_type']),
                                        ]
                                    ),
                                    new Divider(color: Colors.transparent),
                                    new Row(
                                        children: <Widget>[
                                          new Icon(Icons.fastfood,
                                              color: Colors.transparent),
                                          new Text(" ")
                                          ,
                                        ]
                                    ),
                                    new Divider(color: Colors
                                        .transparent)

                                  ]
                              ),
                            ),


                          ]
                      )
                      ,
                      new Row(
                          children: <Widget>[
                            new Icon(Icons.info_outline),
                            new Expanded
                              (child:
                            new Container(padding: const EdgeInsets
                                .only(left: 4.0),
                                child:
                                new Text(
                                    data['description'])
                            )
                            )

                          ]
                      ),
                      new Divider(color:
                      Colors.transparent),


                    ]
                )
            )
          ],
        )
    );
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
}


