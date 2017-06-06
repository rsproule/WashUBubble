import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './loginStuff.dart' as login;


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
  List<DataSnapshot> threads;


  PostPageState(DataSnapshot s) {
    this.postSnapshot = s;
    //_getThreads();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Thread"),

        ),

        body: new Column(
//            physics: const AlwaysScrollableScrollPhysics(),

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
                        onPressed: this.replyIsFilled ? _sendPostResponse : null
                    )
                  ]
              ),


              new Divider(),


              //All the root thread nodes for this post:
              new Flexible(
                  child:

                  new FirebaseAnimatedList(
//                      physics: const AlwaysScrollableScrollPhysics(),

                      query: replyReference.child(this.postSnapshot.key),
                      // the root nodes to the current post
                      defaultChild: new Container(height: 100.0,
                          child: new Center(
                              child: new Text("Be the first to respond"))),
                      itemBuilder: (_, DataSnapshot snapshot,
                          Animation<double> animation) {
                        return
                          //new Text("here");
                          //shows all the nodes but need to check if the parent is the root
                          snapshot.value['parent'] == this.postSnapshot.key?
                          new ReplyTile(
                              snapshot,
                              animation,
                              this.postSnapshot.key
                          ):
                          new Container() // empty container
                        ;
                      }
                  )
              )
            ]
        )
    );
  }

  _sendPostResponse() async {
    String reply = replyController.text;
    GoogleSignInAccount user = login
        .getUser()
        .currentUser;

    await replyReference.child(this.postSnapshot.key).push().set({
      'parent': this.postSnapshot.key,
      'content': reply,
      'children': {
        'hasChildren': false
      },
      'username': user.displayName,
      'photo_url': user.photoUrl,
      'user_id': user.id,
    });

    replyController.clear();
  }

}


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
  List<ReplyTile> childrenTiles= [];
  bool hasChildren;


  ReplyTileState(DataSnapshot s, Animation a, String postKey) {
    this.snapshot = s;
    this.animation = a;
    this.postKey = postKey;
    Map m = s.value['children'];
    m.forEach((k, v){
      if(k == 'hasChildren'){
        hasChildren = v;
      }else{
        threadChildren.add(k);
        DatabaseReference ref = FirebaseDatabase.instance.reference().child("threadNodes")
            .child(postKey).child(k);
        getChildren(ref);
      }

    });
  }

  getChildren(DatabaseReference ref) async{
    DataSnapshot s = await ref.once();
    ReplyTile childTile = new ReplyTile(s, animation, this.postKey);
    this.childrenTiles.add(childTile);
//    print(s.value['content']);
  }


  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Row(
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.all(10.0),
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
                        width: 260.0,
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
                new Container(
                    child: new IconButton(
                        icon: new Icon(Icons.reply),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child:
                              new Dialog( child:
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

                )
              ]
          ),
          new Divider(),
          this.hasChildren

          ? new Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: new Column(children: childrenTiles)
          )
          : new Text("No child")
    
          
        ]

    );
  }

  _sendReply() async {
    threadInPostReference = FirebaseDatabase.instance.reference().child("threadNodes").child("-Klijw0f90DHFV9n_B4D"); // the post container
    String content = replyController.text;
    GoogleSignInAccount user = login.getUser().currentUser;

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
      'children': {                 //new
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