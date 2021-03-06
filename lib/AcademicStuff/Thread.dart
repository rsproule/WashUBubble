import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';

import 'package:google_sign_in/google_sign_in.dart';
import './loginStuff.dart' as login;
import 'package:wububble/AcademicStuff/ReplyTile.dart' as replyTile;
//import './StatelessReplyTile.dart' as reply;


class Thread extends StatefulWidget {
  final String postKey;

  Thread({this.postKey});

  @override
  _ThreadState createState() => new _ThreadState(postKey);
}

class _ThreadState extends State<Thread> {
  int height;

  String postKey;
  DatabaseReference ref = FirebaseDatabase.instance.reference().child(
      'threadNodes');

  _ThreadState(String p) {
    this.postKey = p;
    //_getThreads();
  }

  List<replyTile.ReplyTile> cachedThreads;
  Map cache = new Map();
  bool isLoaded = false;


  _getThreads() async {
    DataSnapshot snapshot = await ref.child(postKey).once();
    Map allThreadsMap = snapshot.value;
    List<replyTile.ReplyTile> cache = [];

    if (allThreadsMap == null) return;

    allThreadsMap.forEach((k, v) async {
      DataSnapshot thread = await ref.child(postKey).child(k).once();
      //check if this snap is a root node
//      Map pr = snapshot.value;
//      print("the first: " + v.toString());
      //String parent = threads.value['parent'];
      Animation<double> animation;
//      Map t = threads.value;


      v.forEach((k1, v1) async {
        if (v1 == this.postKey) {
          cache.add(new replyTile.ReplyTile(
              thread, animation, this.postKey, 0));
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Container(

      /// here to allow the user to scroll back up to the post page
      /// gotta be a better way to do this
        padding: const EdgeInsets.only(top: 50.0),
//        child: new ListView(
//            children: this.isLoaded ?
//
//            this.cachedThreads // all cached threads now stored in memory
//
//
//                : <Widget>[
//              new Center(
//                  child: new Container(
//                      padding: const EdgeInsets.only(top: 20.0),
//                      child: new CircularProgressIndicator()
//                  )
//              ),
//            ]
//        )

        child: new FirebaseAnimatedList(

            defaultChild: new DefaultThreadView(),
            query: ref.child(postKey),
            sort: (a, b) => (a.key.compareTo(b.key)),
            itemBuilder: (context, DataSnapshot snapshot,
                Animation<double> animation) {
              return new FutureBuilder<DataSnapshot>(
                  future: ref.child(postKey).child(snapshot.key).once(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataSnapshot> snap) {
                    Future<DataSnapshot> s = ref.child(postKey).child(
                        snapshot.key).once();
//                    print(cache.length);
                    if (cache.containsKey(snapshot.key)) {
//                        print("loaded from cache");
                      return cache[snapshot.key];
                    }
                    else {
                      switch (snap.connectionState) {
                        case ConnectionState.none:
                          return new Center(
                              child: new CircularProgressIndicator());
                        case ConnectionState.waiting:
                          return new Center(
                              child: new CircularProgressIndicator());
                        default:
                          if (!snap.hasData) {
                            return new Text('Error: ${snap.error}');
                          }
                          else {
                            //check if this snap is a root node
                            String parent = snap.data.value['parent'];

                            if (parent == this.postKey) {
//                              print("new load");
                              replyTile.ReplyTile thread = new replyTile
                                  .ReplyTile(
                                  snap.data, animation, this.postKey, 0);

                              cache.putIfAbsent(snapshot.key, () => thread);
                              print(thread);


                              return thread;
                            } else {
                              return new Container();
                            }
                          }
                      }
                    }
                  }
              );
            }

        )
    );
  }
}


/// Default Widget:


class DefaultThreadView extends StatefulWidget {
  String postKey;
  ListView l;

  DefaultThreadView({this.postKey});

  @override
  _DefaultThreadViewState createState() =>
      new _DefaultThreadViewState(postKey: this.postKey);
}

class _DefaultThreadViewState extends State<DefaultThreadView> {
  bool replyIsFilled = false;
  TextEditingController replyController = new TextEditingController();

  final String postKey;

  _DefaultThreadViewState({this.postKey});

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Center(
              child: new Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: new Text("Be the first to Respond")
              )
          ),
          new Center(
              child: new MaterialButton(
                  child: new Text("Add a response"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new Dialog(
                          child: new Row(
                              children: <Widget>[
                                new Flexible(
                                    child: new TextField(
                                        onChanged: (String val) {
                                          setState(() {
                                            this.replyIsFilled =
                                                val != "";
                                          });
                                        },
                                        controller: replyController,
                                        maxLines: 10,
                                        decoration: new InputDecoration(
                                            hideDivider: true,
                                            hintText: "Add a Response",
                                            icon: new Icon(
                                                Icons.reply)
                                        )
                                    )
                                ),

                                new MaterialButton(
                                    child: new Text("Reply"),
                                    splashColor: Colors.blue,
                                    textColor: Colors.blue,
                                    onPressed: () {
                                      if (tryPost()) {
                                        Navigator.of(context).pop();
                                      } else {
                                        //print("failed to post");
                                        //TODO handle failed post
                                      }
                                    }

                                )
                              ]
                          ),
                        )
                    );
                  }
              )

          ),

        ]
    );
  }

  bool tryPost() {
    String reply = replyController.text;

    if (reply != "") {
      _sendPostResponse();
      return true;
    } else {
      return false;
    }
  }

  _sendPostResponse() async {
    String reply = replyController.text;
    GoogleSignInAccount user = login
        .getUser()
        .currentUser;

    DatabaseReference replyReference = FirebaseDatabase.instance.reference()
        .child("threadNodes");

    if (reply != "") {
      await replyReference.child(this.postKey).push().set({
        'parent': this.postKey,
        'content': reply,
        'children': {
          'hasChildren': false
        },
        'username': user.displayName,
        'photo_url': user.photoUrl,
        'user_id': user.id,
      });

      replyController.clear();

      //update state:
//      _getThreads(replyReference.child(
//          this.postSnapshot.key));
    }
  }
}





