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
  DataSnapshot postSnapshot;
  bool replyIsFilled = false;
  TextEditingController replyController = new TextEditingController();
  DatabaseReference replyReference = FirebaseDatabase.instance.reference()
      .child("threadNodes");


  PostPageState(DataSnapshot s) {
    this.postSnapshot = s;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Thread"),

        ),

        body: new ListView(
            physics: const AlwaysScrollableScrollPhysics(),

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
                            child: this.postSnapshot.value['photo_url'] !=
                                null
                                ? new GoogleUserCircleAvatar(
                                this.postSnapshot.value['photo_url']
                            ) :
                            new CircleAvatar(child: new Text("?"))
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
                                    this.postSnapshot.value['timestamp'] !=
                                        null
                                        ? this.postSnapshot
                                        .value['timestamp']
                                        : "Uknown Time"
                                    ,
                                    style: Theme
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
                    "     " + this.postSnapshot.value['post'],
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead, textAlign: TextAlign.left),
              ),

              new Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Divider(height: 30.0)
              ),

              //Main response field:
              new Row(
                  children: <Widget>[
                    new Flexible(
                        child: new TextField(
                            onChanged: (String val) {
                              setState(() {
                                this.replyIsFilled = val != "";
                              });
                            },
                            controller: replyController,
                            maxLines: 3,
                            decoration: new InputDecoration(
                                hideDivider: true,
                                hintText: "Add a Response",
                                icon: new Icon(Icons.reply)
                            )
                        )
                    ),

                    new MaterialButton(
                        child: new Text("Reply"),
                        splashColor: Colors.blue,
                        textColor: this.replyIsFilled ? Colors.blue : Colors
                            .grey,
                        onPressed: this.replyIsFilled ? _postReply : null
                    )
                  ]
              ),


              new Divider(),


              //All the root thread nodes for this post:
//              new Flexible(
//                  child: new FirebaseAnimatedList(
//                      physics: const AlwaysScrollableScrollPhysics(),
//
//                      query: replyReference.child(postSnapshot.key),
//                      // the root nodes to the current post
//                      defaultChild: new Container(height: 100.0,
//                          child: new Center(
//                              child: new Text("Be the first to respond"))),
//                      itemBuilder: (_, DataSnapshot snapshot,
//                          Animation<double> animation) {
//                        return new Column(
//                            children: <StatefulWidget>[
//                              new ReplyTile(
//                                  snapshot, animation,
//                                  this.postSnapshot.key)
//
//                            ]
//                        );
//                      }
//                  )
//
//              )

            ]

        )

    );
  }

  _postReply() async {
    String reply = replyController.text;

    await replyReference.child(this.postSnapshot.key).push().set({
      'parent': null,
      'content': reply
    });

    replyController.clear();
  }

  void _refresh() {
    //this will set the graph of nodes with setState ?

  }
}

class ReplyTile extends StatefulWidget {
  DataSnapshot s;
  Animation a;
  String parent;

  ReplyTile(DataSnapshot s, Animation a, String parent) {
    this.s = s;
    this.a = a;
    this.parent = parent;
  }

  @override
  ReplyTileState createState() => new ReplyTileState(s, a, parent);
}

class ReplyTileState extends State<ReplyTile> {
  DataSnapshot snapshot;
  Animation animation;
  String parent;
  DatabaseReference replyReference = FirebaseDatabase.instance.reference()
      .child("threadNodes");


  ReplyTileState(DataSnapshot s, Animation a, String parent) {
    this.snapshot = s;
    this.animation = a;
  }


  Widget build(BuildContext context) {
    return new Text(snapshot.value['content']);
//
//
// Column(
//      children: <Widget> [
//
//
//
//        //any children
//        new Container(
//            child: new FirebaseAnimatedList(
//                query: replyReference.child(this.parent),
//                defaultChild: new Container(height: 100.0, child: new Center(child: new Text("Respond"))),
//                itemBuilder: (_, DataSnapshot snapshot,
//                    Animation<double> animation) {
//                  return new Column(
//                      children: <StatefulWidget>[
//                        new ReplyTile(snapshot, animation, this.parent)
//                      ]
//                  );
//                }
//            )
//        )
//      ]
//    );
  }
}