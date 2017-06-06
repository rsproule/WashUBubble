import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './loginStuff.dart' as login;

class ReplyTile extends StatefulWidget {
  DataSnapshot s;
  Animation a;
  String postKey;

  ReplyTile(DataSnapshot s, Animation a, String parent) {
    this.s = s;
    this.a = a;
    this.postKey = parent;
  }

  @override
  ReplyTileState createState() => new ReplyTileState(s, a, postKey);
}

class ReplyTileState extends State<ReplyTile> {
  DataSnapshot snapshot;
  Animation animation;
  String postKey;
  DatabaseReference threadInPostReference;
  TextEditingController replyController = new TextEditingController();
  List<String> threadChildren = [];
  List<ReplyTile> childrenTiles = [];
  bool hasChildren;


  ReplyTileState(DataSnapshot s, Animation a, String postKey) {
    this.snapshot = s;
    this.animation = a;
    this.postKey = postKey;
    Map m = s.value['children'];
    m.forEach((k, v) {
      if (k == 'hasChildren') {
        hasChildren = v;
      } else {
        threadChildren.add(k);
        DatabaseReference ref = FirebaseDatabase.instance.reference().child(
            "threadNodes")
            .child(postKey).child(k);
        getChildren(ref);
      }
    });
  }

  getChildren(DatabaseReference ref) async {
    DataSnapshot s = await ref.once();
    Animation<double> animation1;
    ReplyTile childTile = new ReplyTile(s, animation1, this.postKey);
    setState(() {
      this.childrenTiles.add(childTile);
    });
//    print(s.value['content']);
  }


  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Row(
              children: <Widget>[
                new Container(
                    child: new IconButton(
                        icon: new Icon(Icons.reply),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child:
                              new Dialog(child:
                              new Container(
                                  height: 300.0,
                                  child: new Column(
                                      children: <Widget>[
                                        new TextField(
                                            controller: replyController,
                                            decoration: new InputDecoration(
                                              hintText: "Response Message",
                                              icon: new Icon(Icons.reply),
                                              hideDivider: true,

                                            )
                                        ),
                                        new Divider(),

                                        new MaterialButton(
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            child: new Text("Send"),
                                            onPressed:
                                            _sendReply

                                        )
                                      ]
                                  )
                              )


                              )
                          );
                        }
                    )

                ),
                new Container(
                    margin: const EdgeInsets.only(
                        right: 10.0, top: 10.0, bottom: 10.0),
                    child: snapshot.value['photo_url'] !=
                        null
                        ? new GoogleUserCircleAvatar(
                        snapshot.value['photo_url']
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
                            snapshot.value['username'],
                            style: Theme
                                .of(context)
                                .textTheme
                                .subhead),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0),
                        child: new Text(
                            snapshot.value['content']
                            ,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption),
                      ),

                    ]
                ),

              ]
          ),
//          new Divider(),
          this.hasChildren

              ? new Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: new Column(children: childrenTiles)
          )
              : new Container()


        ]

    );
  }

  _sendReply() async {

    threadInPostReference = FirebaseDatabase.instance.reference().child("threadNodes").child(
            snapshot.value['parent']); // the post container
    String content = replyController.text;
    GoogleSignInAccount user = login
        .getUser()
        .currentUser;

    DatabaseReference newRef = threadInPostReference.push();
    String newKey = newRef.key;

    await newRef.set({
      "parent": this.snapshot.key,
      "content": content,
      'children': {
        'hasChildren': false
      },
      'username': user.displayName,
      'photo_url': user.photoUrl,
      'user_id': user.id
    });


    //update the parents children
    await threadInPostReference.child(this.snapshot.key).set({
      //this info is for the new response, look up how to do update!!! --> cant find anything :(
      //this deletes everything that is there... i think we can replace with all snapshot data np
      "parent": snapshot.value['parent'],
      "content": snapshot.value['content'],
      'children': { //new
        'hasChildren': true,
        newKey: true
      },
      'username': snapshot.value['username'],
      'photo_url': snapshot.value['photo_url'],
      'user_id': snapshot.value['user_id']
    });

    replyController.clear();
  }
}