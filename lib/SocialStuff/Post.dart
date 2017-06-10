import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return

      new Card(
          child: new Column(
              children: <Widget>[

//                new Container(
//
//                    padding: const EdgeInsets.only(left: 10.0, top: 5.0),
//                    child: new Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//
//                          new Text("Title", style: Theme
//                              .of(context)
//                              .textTheme
//                              .title),
//
//                          new Text(
//                              "     This is a post of a snow tiger that looks cool as shit",
//                              style: Theme
//                                  .of(context)
//                                  .textTheme
//                                  .subhead),
//                        ])
//
//
//                ),
                //image or media
                new Container(
                  padding: const EdgeInsets.all(4.0),
                  child: new Image.network(
                      "https://wallpaperbrowse.com/media/images/8DJWnR85.jpg",
                      height: 380.0,
                      width: 400.0
                  ),
                ),
                //user info :
                new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new Row(
                        children: <Widget>[
                          new CircleAvatar(
                              child: new Icon(Icons.person)),
                          new Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text("Ryan Sproule", style: Theme
                                        .of(context)
                                        .textTheme
                                        .title),
                                    new Text(
                                        "Jan 13, 1997 3:15 PM", style: Theme
                                        .of(context)
                                        .textTheme
                                        .subhead)
                                  ]
                              )
                          ),

                        ]
                    )
                )


              ]
          )
      );
  }
}


