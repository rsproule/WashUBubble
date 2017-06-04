import 'dart:async';
import 'package:flutter/material.dart';
import './PostQuestion.dart' as newQuestion;
import './PostTile.dart' as post;
import './loginStuff.dart' as login;

import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class ClassPage extends StatefulWidget{
  String classKey = "";
  String name = "loading class...";

  //eventually will pull in the class id so
  // that the rest of the class data can be fetched
  // ie the questions and meta data about them
  ClassPage(String key) {
    this.classKey = key;
  }


  @override
  ClassPageState createState() => new ClassPageState(classKey, name);
}

class ClassPageState extends State<ClassPage> {
  String classKey, name, professor, code;

  //eventually will pull in the class id so
  // that the rest of the class data can be fetched
  // ie the questions and meta data about them
  ClassPageState(String key, String name) {
    this.classKey = key;
    this.name = name;
    getClassInfo(key);
  }

  final postsReference = FirebaseDatabase.instance.reference().child('posts');


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(this.name),
          actions: <Widget>[
            new IconButton(icon: new Icon(
                Icons.info_outline, color: Colors.white),
                onPressed: showInfo
            )
          ]
      ),
      body: new Column(
        children: <Widget> [
          new Flexible(
              child: new FirebaseAnimatedList(
                  query: postsReference.child(this.classKey),
                  defaultChild: new Center(
                      child: new CircularProgressIndicator()),
                  sort: (a, b) => b.key.compareTo(a.key),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation) {
                    return new Column(
                        children: <StatefulWidget>[
                          new post.PostTile(
                            snapshot: snapshot,
                            animation: animation,
                          )
                        ]
                    );
                  }

              )
          )
        ]
      ),

      persistentFooterButtons: <Widget>[
        new IconButton(icon: new Icon(
            Icons.create, color: Colors.blueGrey),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new newQuestion.PostQuestion(this.classKey);
                  }
              )
              );
            }

        ),

      ],


    );
  }

  Future getClassInfo(classKey) async {
    login.checkLogin();

    final reference = FirebaseDatabase.instance.reference().child('classes');
    DataSnapshot s = await reference.child(classKey).once();

    String name, professor, code;
    Map result = s.value;
    result.forEach((k,v){
      if(k == "name"){
        name = v;
      }
      else if(k == "professor"){
        professor = v;
      }
      else if(k == "code"){
        code = v;
      }
    });

    setState((){
      this.name = name;
      this.professor = professor;
      this.code = code;
    });

  }

  void showInfo(){
      showDialog(
          context: context,
          child: new Dialog(
            child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  maxHeight: 140.1,
                  maxWidth: 10.1,
                  minHeight: 100.0,
                  minWidth: 10.0,
                ),
                child: new Column(
                    children: <Widget> [
                      new Divider(color: Colors.transparent),
                      new Text(this.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.title),
                      new Divider(color: Colors.transparent),
                      new Text(this.code + " - " + this.professor, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subhead),

                      new Divider(color: Colors.transparent, height: 12.0),
                      new Icon(Icons.school, size: 50.0, color: Theme.of(context).accentColor)
                    ]
                )
            )
          )
      );
  }
}

