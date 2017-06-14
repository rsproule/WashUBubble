import 'dart:async';
import 'package:flutter/material.dart';
import '../AcademicStuff/loginStuff.dart' as login;
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  bool nameHasError = false;
  bool groupHasError = false;
  bool foodHasError = false;
  bool descriptionHasError = false;
  bool locationHasError = false;


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
                      errorText: nameHasError ? "Required Field" : ""

                  )
              ),
              new Divider(),
              new TextField(
                  controller: _groupNameController,
                  decoration: new InputDecoration(
                      hintText: "Organization Name",
                      hideDivider: true,
                      icon: new Icon(Icons.group),
                      errorText: groupHasError ? "Required Field" : ""


                  )
              ),
              new Divider(),
              new TextField(
                  controller: _foodController,
                  decoration: new InputDecoration(
                      hintText: "What kind of food will be there?",
                      hideDivider: true,
                      icon: new Icon(Icons.fastfood),
                      errorText: foodHasError ? "Required Field" : ""


                  )
              ),

              new Divider(),
              new TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: new InputDecoration(
                      hintText: "Quick description of group + event",
                      hideDivider: true,
                      icon: new Icon(Icons.info_outline),
                      errorText: descriptionHasError ? "Required Field" : ""

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
                                      initialDate: new DateTime(
                                          day.year, day.month, day.day + 1),
                                      firstDate: new DateTime(
                                          day.year, day.month, day.day + 1),
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
                      icon: new Icon(Icons.location_on),
                      errorText: locationHasError ? "Required Field" : ""


                  )
              ),

              new Divider(),

//          new Container(
//              child: new Text("Add location", style: Theme.of(context).textTheme.subhead),
//              padding: const EdgeInsets.only(left: 15.0, top: 15.0)
//          ),
//
//              new Row(
//                  children: <Widget>[
//                    new Text("location selecter here")
//                  ]
//              ),


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

  _handleSubmit(bool success, String message, [String failedField]) {
    if (success) {
      //clear all text fields
      _nameController.clear();
      _groupNameController.clear();
      _descriptionController.clear();
      _foodController.clear();
      _locationController.clear();

      Navigator.of(context).pop();
      _successDialog();
    }
    else {
      switch (failedField) {
        case "name":
          setState(() {
            nameHasError = true;
          });
          break;
        case "group":
          setState(() {
            groupHasError = true;
          });
          break;
        case "description":
          setState(() {
            descriptionHasError = true;
          });
          break;
        case "food":
          setState(() {
            foodHasError = true;
          });
          break;
        case "location":
          setState(() {
            locationHasError = true;
          });
          break;
        default:
          _failureDialog(message);
          break;
      }
    }

    //  print(message);
  }

  _submitEvent() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child(
        'foodEvents');
    bool isValid = true;

    nameHasError = false;
    foodHasError = false;
    groupHasError = false;
    descriptionHasError = false;
    locationHasError = false;

    String name = _nameController.text;
    if (name == "") {
      _handleSubmit(false, "Event Name Field empty", "name");
      isValid = false;
    }

    String group = _groupNameController.text;
    if (group == "") {
      _handleSubmit(false, "Group Name Field empty", "group");
      isValid = false;
    }

    String foodType = _foodController.text;
    if (foodType == "") {
      _handleSubmit(false, "Food Field empty", "food");
      isValid = false;
    }

    String description = _descriptionController.text;
    if (description == "") {
      _handleSubmit(false, "Description Field empty", "description");
      isValid = false;
    }

    String location = _locationController.text;
    if (location == "") {
      _handleSubmit(false, "Location Field empty", "location");
      isValid = false;
    }


    /// Verification on the times the user input.
    /// Cannot be starting after it ended and must be a min 30 min long

    if (this.startTime.hour > this.endTime.hour) {
      _handleSubmit(false, "Start time must be before end time");
      isValid = false;
    } else {
      if (this.startTime.hour == this.endTime.hour) {
        if (this.startTime.minute >= this.endTime.minute - 30) {
          _handleSubmit(false,
              "Start time must be before end time (event must be atleast 30 min long)");
          isValid = false;
        }
      }
    }

    if (this.day
        .difference(new DateTime.now())
        .inDays < 1) {
      _handleSubmit(false,
          "Date of event must be in the future (at least one day in advance)");
      isValid = false;
    }

    this.day = new DateTime(this.day.year, this.day.day, this.startTime.hour,
        this.startTime.minute);
    String date = this.day
        .toString(); // convert back back with DateTime.parse()
    String startTime = this.startTime.toString();
    String endTime = this.endTime.toString();


    if (isValid) {
      Future post = ref.push().set({
        "name": name,
        "group_name": group,
        "food_type": foodType,
        "description": description,
        "location": location,
        "date": date,
        "start_time": startTime,
        "end_time": endTime
      });

      post.then((value) => _handleSubmit(true, "success"))
          .catchError((error) => _handleSubmit(false, error));
    }
  }

  _successDialog() {
    showDialog(
      child: new Dialog(

          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.1,
                maxWidth: 10.1,
                minHeight: 100.0,
                minWidth: 10.0,
              ),
              child: new Column(
                  children: <Widget>[
                    new Divider(color: Colors.white),
                    new Text(
                        "Submitted Successfully!", textAlign: TextAlign.center),
                    new Divider(color: Colors.white, height: 12.0),
                    new Icon(Icons.check, size: 50.0, color: Colors.green)
                  ]
              )
          )
      ),
      context: context,

    );
  }

  _failureDialog(String message) {
    showDialog(
      child: new Dialog(

          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 150.1,
                maxWidth: 10.1,
                minHeight: 100.0,
                minWidth: 10.0,
              ),
              child: new Column(
                  children: <Widget>[
                    new Divider(color: Colors.white),
                    new Text(message, textAlign: TextAlign.center),
                    new Divider(color: Colors.white, height: 12.0),
                    new Icon(Icons.cancel, size: 50.0, color: Colors.red)
                  ]
              )
          )
      ),
      context: context,

    );
  }

}
