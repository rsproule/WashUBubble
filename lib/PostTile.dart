import 'dart:math';
import 'package:flutter/material.dart';
import './loginStuff.dart' as login;

import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class PostTile extends StatefulWidget{
  final DataSnapshot snapshot;
  final Animation animation;

  PostTile({this.snapshot, this.animation});
  @override
  PostTileState createState() => new PostTileState(this.snapshot, this.animation);
}

class PostTileState extends State<PostTile>{
  DataSnapshot snapshot;
  Animation animation;

  Random r = new Random();
  List<MaterialColor> colors = Colors.primaries;
  Color backgroundColor;

  PostTileState(snapshot, animation){
    this.snapshot = snapshot;
    this.animation = animation;
    this.backgroundColor = colors.elementAt(r.nextInt(colors.length));
  }

  @override
  Widget build(BuildContext context){
    return new Column(
      children: <Widget> [
      new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animation, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child:
        new ListTile(
          title: new Text(
              snapshot.value['subject'],
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
          ),
          leading:
          snapshot.value['photo_url'] != null
            ? new GoogleUserCircleAvatar(snapshot.value['photo_url'])
            : new CircleAvatar(child: new Text("?"), backgroundColor: backgroundColor)
          ,
          subtitle: new Text(
              snapshot.value == null
              ? "Anonymous - " + snapshot.value['tag']
              : snapshot.value['username'] + " - " + snapshot.value['tag']
          ),


        )


    ),
        new Divider()
    ]
    );
  }

}