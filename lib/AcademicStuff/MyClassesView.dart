import 'package:flutter/material.dart';
import './ClassPage.dart' as classPage;
import './loginStuff.dart' as login;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class MyClassesView extends StatefulWidget {
  @override
  MyClassesViewState createState() => new MyClassesViewState();
}

class MyClassesViewState extends State<MyClassesView> {

  DatabaseReference usersClasses = FirebaseDatabase.instance.reference().child(
      'members');
  bool isLoaded;

  MyClassesViewState() {
    isLoaded = false;
    _loadUserInfo();
    //this is being called before the login sequence completes and failing on null

  }


  _loadUserInfo() async {
    await login.checkLogin();
    GoogleSignIn user = login.getUser();
    setState(() {
      usersClasses = usersClasses.child(user.currentUser.id);
      isLoaded = true;
    });
  }


  Widget build(BuildContext context) {
    return this.isLoaded
        ?

    new Column(
        children: <Widget>[
          new Flexible(
              child: new FirebaseAnimatedList(
                  query: usersClasses,
                  defaultChild: new Center(
                      child: new CircularProgressIndicator()
                  ),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation) {
                    return new Column(
                        children: <StatefulWidget>[
                          new ClassTile(
                            snapshot: snapshot,
                            animation: animation,
                          )
                        ]
                    );
                  }

              )

          )
        ]
    )
        : new Center(
        child:
        new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orangeAccent)
        )
    )
    ;
  }

}

class ClassTile extends StatefulWidget {
  final DataSnapshot snapshot;
  final Animation animation;

  ClassTile({this.snapshot, this.animation});

  @override
  ClassTileState createState() =>
      new ClassTileState(this.snapshot, this.animation);

}

class ClassTileState extends State<ClassTile> {
  DataSnapshot snapshot;
  Animation animation;

  bool UserIsMember = false;
  final reference = FirebaseDatabase.instance.reference().child('members');


  ClassTileState(snapshot, animation) {
    this.snapshot = snapshot;
    this.animation = animation;
  }


  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(snapshot.value['name'], style: Theme
                .of(context)
                .textTheme
                .subhead),
            leading: new Icon(Icons.school),
            subtitle: new Text(
                snapshot.value['code'] + " - " + snapshot.value['professor']),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new Container(
                        child: new classPage.ClassPage(snapshot.key)
                    );
                  }
              )
              );
            },
          ),
          new Divider()
        ]

    );
  }


}