import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';


class PostPage extends StatefulWidget {
  DataSnapshot postSnapshot;

  PostPage(DataSnapshot s) {
    this.postSnapshot = s;
  }

  @override
  PostPageState createState() => new PostPageState(this.postSnapshot);
}

class PostPageState extends State<PostPage> {
  DatabaseReference postRef;

  DataSnapshot postSnapshot;

  PostPageState(DataSnapshot s) {
    this.postSnapshot = s;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Thread"),

        ),
        body: new Column(
            children: <Widget>[
              //Subject of post:
              new Center(
                  child: new Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: new Text(
                        this.postSnapshot.value['subject'], style: Theme
                        .of(context)
                        .textTheme
                        .title),
                  )
              ),
              new Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Divider(height: 30.0)
              ),

              // User information and time of post:
              new Container(
                  child: new Row(
                      children: <Widget>[
                        new Container(
                            margin: const EdgeInsets.all(10.0),
                            child: new GoogleUserCircleAvatar(
                                this.postSnapshot.value['photo_url'])
                        ),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: new Text(
                                    this.postSnapshot.value['username'],
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .subhead),
                              ),
                              new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: new Text(
                                    "Jan 13, 2017 5:34 PM", style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption),
                              ),

                            ]
                        ),
                      ]
                  )
              ),

              new Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Divider(height: 30.0)
              ),

              //Question or post body:
              new Container(
                margin: const EdgeInsets.all(10.0),
                alignment: FractionalOffset.topLeft,

                child: new Text(
                    this.postSnapshot.value['post'],
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead, textAlign: TextAlign.left),
              ),

              new Divider()

            ]
        )
    );
  }
}