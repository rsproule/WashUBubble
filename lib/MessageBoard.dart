import 'package:flutter/material.dart';
import './loginStuff.dart' as login;
import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class MessageBoard extends StatefulWidget {
  String classKey;

  MessageBoard(String k) {
    this.classKey = k;
  }

  @override
  MessageBoardState createState() => new MessageBoardState(this.classKey);
}


class MessageBoardState extends State<MessageBoard> {
  String classKey;
  final TextEditingController _messageController = new TextEditingController();
  final reference = FirebaseDatabase.instance.reference().child('messages');
  bool isTyping = false;


  MessageBoardState(String k) {
    this.classKey = k;
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[

          new Flexible(
            child: new FirebaseAnimatedList(
                reverse: true,
                sort: (a, b) => (b.key.compareTo(a.key)),
                padding: new EdgeInsets.all(8.0),
                query: reference.child(this.classKey),
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation) {
                  return new Column(
                      children: <Widget>[
                        new Message(
                          snapshot: snapshot,
                          animation: animation,
                        )
                      ]
                  );
                }
            ),
          ),
          new Divider(),
          new Container(
              padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),

              child: new Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.text,
                          onChanged: (String val){

                              setState((){
                                isTyping = val != "";
                              });

                          },
                          maxLines: 20,
                          decoration: new InputDecoration.collapsed(
                            hintText: "Send a Message",

                          )

                      ),
                    ),

                    new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: isTyping ? _sendMessage : null
                    )
                  ]
              )
          ),


        ]
    );
  }

  _sendMessage() async {
    GoogleSignInAccount user = login
        .getUser()
        .currentUser;
    String message = _messageController.text;

    await reference.child(this.classKey).push().set({
      "message": message,
      "username": user.displayName,
      "user_id": user.id,
      "photo_url": user.photoUrl
    });

    _messageController.clear();
    setState((){
      isTyping = false;
    });
  }
}

class Message extends StatelessWidget {
  final DataSnapshot snapshot;
  final Animation animation;

  Message({this.snapshot, this.animation});

  Widget build(BuildContext context) {
    return new SizeTransition(

      sizeFactor: new CurvedAnimation(
          parent: animation, curve: Curves.easeOut
      ),
      child: new Container(
          margin: new EdgeInsets.symmetric(vertical: 10.0),
          padding: new EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
              children: <Widget>[
                new Container(
                  child: new GoogleUserCircleAvatar(
                      snapshot.value['photo_url']),
                  margin: const EdgeInsets.only(right: 16.0),
                ),
                new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(snapshot.value['username'], style: Theme
                          .of(context)
                          .textTheme
                          .subhead,

                      ),
                      new Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 125.0,
                          child: new Text(snapshot.value['message'],
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1,
                          )
                      ),
                    ]
                )
              ]
          )
      ),
    );
  }

}

