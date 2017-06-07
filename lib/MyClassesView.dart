import 'package:flutter/material.dart';
import './ClassPage.dart' as classPage;
import './loginStuff.dart' as login;
import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class MyClassesView extends StatefulWidget {
  @override
  MyClassesViewState createState() => new MyClassesViewState();
}

class MyClassesViewState extends State<MyClassesView> {

  final classReference = FirebaseDatabase.instance.reference().child('classes');

  Comparator alphabetical = (a, b) {
    String aName = a.value['name'];
    String bName = b.value['name'];
    return aName.compareTo(bName);
  };


  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new Flexible(
              child: new FirebaseAnimatedList(
                  query: classReference,
                  sort: alphabetical,
                  defaultChild: new Center(
                      child: new CircularProgressIndicator()),
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
    );
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
    GoogleSignIn userInfo = login.getUser();
    this.snapshot = snapshot;
    this.animation = animation;
    checkIfMember(userInfo.currentUser.id);
  }

  checkIfMember(id) async{
    DataSnapshot s = await reference.child(snapshot.key).once();
    Map result = s.value;
    bool isMem = false;

    if(s.value != null) {
      result.forEach((k, v){
        Map p = v;
        isMem = (p.containsKey(id));
      });
    }
    setState((){
      UserIsMember = isMem;
    });
  }

  Widget build(BuildContext context) {
    return this.UserIsMember ? new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(snapshot.value['name'], style: Theme
                .of(context)
                .textTheme
                .subhead),
            leading: new Icon(Icons.school),
            subtitle: new Text(snapshot.value['code'] + " - " + snapshot.value['professor']),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new Container(
                      child:  new classPage.ClassPage(snapshot.key)
                    );


                  }
              )
              );
            },
          ),
          new Divider()
        ]

    ) : new Container();
  }


}