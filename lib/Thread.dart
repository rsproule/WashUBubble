import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './loginStuff.dart' as login;
import './ReplyTile.dart' as replyTile;


class Thread extends StatefulWidget {
  final String postKey;

  Thread({this.postKey});

  @override
  _ThreadState createState() => new _ThreadState(postKey: postKey);
}

class _ThreadState extends State<Thread> {
  final String postKey;
  DatabaseReference ref = FirebaseDatabase.instance.reference().child(
      'threadNodes');

  _ThreadState({this.postKey});


  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.only(top: 50.0),

        /// here to allow the user to scroll back up to the post page
        child: new FirebaseAnimatedList(
            defaultChild: new DefaultThreadView(),
            query: ref.child(postKey),
            sort: (a, b) => (a.key.compareTo(b.key)),
            itemBuilder: (context, DataSnapshot snapshot,
                Animation<double> animation) {
              Map m = snapshot.value;
//            print("Map: " + m.toString());
//            print("Key: " + snapshot.key);
              return new FutureBuilder<DataSnapshot>(
                  future: ref.child(postKey).child(snapshot.key).once(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DataSnapshot> snap) {
                    switch (snap.connectionState) {
                      case ConnectionState.none:
                        return new Text('Connecting...');
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        if (!snap.hasData) {
                          return new Text('Error: ${snap.error}');
                        }
                        else {
                          //check if this snap is a root node
                          Map m = snap.data.value['children'];
                          bool isRoot = false;
                          m.forEach((k, v) {
                            if (k == 'hasChildren') {
                              isRoot = v;
                            }
                          });

                          if (isRoot) {
                            return new replyTile.ReplyTile(
                                snap.data, animation, this.postKey, 0);
                          }

                          //return new Text("here determine if a root or not, display if root");

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





