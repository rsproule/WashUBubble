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
  TimeOfDay startTime = new TimeOfDay(hour: 16, minute: 00);
  TimeOfDay endTime = new TimeOfDay(hour: 18, minute: 00);


  TextEditingController _nameController = new TextEditingController();
  TextEditingController _groupNameController = new TextEditingController();
  TextEditingController _foodController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();


  bool isOnCampus = true;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("New Event"),

        ),

        body: new ListView(
            children: <Widget>[

              new TextFormField(
                  controller: _nameController,
                  decoration: new InputDecoration(
                    hintText: "Event Name",
                    hideDivider: true,
                    icon: new Icon(Icons.title),

                  )
              ),
              new Divider(),
              new TextField(
                  controller: _groupNameController,
                  decoration: new InputDecoration(
                    hintText: "Organization Name",
                    hideDivider: true,
                    icon: new Icon(Icons.group),

                  )
              ),
              new Divider(),
              new TextField(
                  controller: _foodController,
                  decoration: new InputDecoration(
                    hintText: "What kind of food will be there?",
                    hideDivider: true,
                    icon: new Icon(Icons.fastfood),

                  )
              ),

              new Divider(),
              new TextField(
                  controller: _foodController,
                  maxLines: 5,
                  decoration: new InputDecoration(
                    hintText: "Quick description of group + event",
                    hideDivider: true,
                    icon: new Icon(Icons.event),
                  )
              ),

              new Divider(),

              new Divider(color: Colors.transparent),

              new Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: new Text("Set a date and time:", style: Theme
                    .of(context)
                    .textTheme
                    .subhead),


              ),

              new Center(
                child:
                new Row(children: <Widget>[

                  new Container(
                      padding: const EdgeInsets.all(15.0),
                      child:
                      new Column(
                          children: <Widget>[
                            new Text("Date:"),
                            new Container(
                              child: new IconButton(
                                  icon: new Icon(Icons.event),
                                  onPressed: () async {
                                    showDatePicker(context: context,
                                      initialDate: day,
                                      firstDate: new DateTime(day.year - 10),
                                      lastDate: new DateTime(day.year + 10),
                                    ).then((day) {
                                      if (day != null) {
                                        setState(() {
                                          this.day = day;
                                        });
                                      }
                                    });
                                  }
                              ),
                            ),

                            new Center(
                              child: new Text(
                                  months[day.month - 1] + " " +
                                      day.day.toString() +
                                      ", " +
                                      day.year.toString()),
                            ),
                          ]
                      )
                  ),

                  new Container(
                    padding: const EdgeInsets.only(left: 45.0),
                    child:
                    new Column(
                        children: <Widget>[
                          new Text("Start Time:"),
                          new Container(
                            child: new IconButton(
                                icon: new Icon(Icons.timer),
                                onPressed: () async {
                                  showTimePicker(context: context,
                                      initialTime: this.startTime
                                  ).then((startTime) {
                                    if (startTime != null) {
                                      setState(() {
                                        this.startTime = startTime;
                                      });
                                    }
                                  });
                                }
                            ),
                          ),

                          new Center(
                            child: new Text(startTime.toString()),
                          ),

                        ]
                    ),
                  ),
                  new Text("  --", style: Theme
                      .of(context)
                      .textTheme
                      .title),
                  new Container(
                    padding: const EdgeInsets.all(15.0),
                    child:
                    new Column(
                        children: <Widget>[
                          new Text("End Time:"),
                          new Container(
                            child: new IconButton(
                                icon: new Icon(Icons.timer),
                                onPressed: () async {
                                  showTimePicker(context: context,
                                      initialTime: this.endTime
                                  ).then((t) {
                                    if (t != null) {
                                      setState(() {
                                        this.endTime = t;
                                      });
                                    }
                                  });
                                }
                            ),
                          ),

                          new Center(
                            child: new Text(endTime.toString()),
                          ),

                        ]
                    ),
                  )
                ]
                ),

              ),
              new Divider(),

              new TextField(
                  controller: _locationController,
                  decoration: new InputDecoration(
                    hintText: "Where is the event? (i.e. Mudd Field) ",
                    hideDivider: true,
                    icon: new Icon(Icons.my_location),

                  )
              ),

              new Divider(),

//          new Container(
//              child: new Text("Add location", style: Theme.of(context).textTheme.subhead),
//              padding: const EdgeInsets.only(left: 15.0, top: 15.0)
//          ),

              new Row(
                  children: <Widget>[
                    new Text("location selecter here")
                  ]
              ),


              new Divider(height: 25.0, color: Colors.transparent),

              new Center(
                  child: new MaterialButton(
                      color: Colors.blue,
                      onPressed: () => _submitEvent(),
                      elevation: 10.0,

                      highlightColor: Colors.blueGrey,
                      highlightElevation: 5.0,
                      child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.add, color: Colors.white),
                            new Text("Submit Event",
                                style: new TextStyle(color: Colors.white))
                          ]
                      )
                  )
              ),
              new Container(height: 400.0),


            ]

        )
    );
  }

  _submitEvent() {

  }
}
