import 'package:flutter/material.dart';

class NewEventForm extends StatefulWidget {
  @override
  _NewEventFormState createState() => new _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  List<String> months = ["January", "February",
  "March", "April", "May", "June", "July", "August",
  "September", "October", "November", "December"
  ];

  DateTime day = new DateTime.now();
  TimeOfDay time = new TimeOfDay(hour: 16, minute: 00);


  @override
  Widget build(BuildContext context) {
    return new ListView(
        children: <Widget>[


          new TextField(
              decoration: new InputDecoration(
                hintText: "Event Name",
                hideDivider: true,
                icon: new Icon(Icons.title),

              )
          ),
          new Divider(),
          new TextField(
              decoration: new InputDecoration(
                hintText: "Organization Name",
                hideDivider: true,
                icon: new Icon(Icons.group),

              )
          ),
          new Divider(),
          new TextField(
              decoration: new InputDecoration(
                hintText: "What kind of food will be there?",
                hideDivider: true,
                icon: new Icon(Icons.fastfood),

              )
          ),
          new Divider(),

          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new Text(
                    months[day.month - 1] + " " + day.day.toString() + ", " +
                        day.year.toString()),
                new IconButton(
                    icon: new Icon(Icons.event),
                    onPressed: () async {
                      showDatePicker(context: context,
                        initialDate: day,
                        firstDate: new DateTime(day.year - 10),
                        lastDate: new DateTime(day.year + 10),
                      ).then((day) {
                        setState(() {
                          day = day;
                        });
                      });
                    }
                )

              ]

          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new Text(time.toString()),
                new IconButton(
                    icon: new Icon(Icons.timer),
                    onPressed: () async {
                      showTimePicker(context: context,
                          initialTime: new TimeOfDay.now()
                      ).then((startTime) {
                        startTime = startTime;
                      });
                    }
                )

              ]

          ),


        ]
    );
  }
}
