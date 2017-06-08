import 'package:flutter/material.dart';
import './loginStuff.dart' as login;
import 'package:google_sign_in/google_sign_in.dart';

// Firebase db stuff:
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AllClassesView extends StatefulWidget {
  @override
  AllClassesViewState createState() => new AllClassesViewState();
}


class AllClassesViewState extends State<AllClassesView> {

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


class ClassTile extends StatefulWidget{
  final DataSnapshot snapshot;
  final Animation animation;

  ClassTile({this.snapshot, this.animation});


  @override
  ClassTileState createState() => new ClassTileState(this.snapshot, this.animation);
}


class ClassTileState extends State<ClassTile> {
   DataSnapshot snapshot;
   Animation animation;
   final reference = FirebaseDatabase.instance.reference().child('members');


   bool userIsMember = false;

  ClassTileState(snapshot, animation) {
    GoogleSignIn userInfo = login.getUser();
    this.snapshot = snapshot;
    this.animation = animation;
    userIsMember = checkIfMember(userInfo.currentUser.id);

  }

   bool checkIfMember(user_id) {
    Map classMembers = snapshot.value['members'];
    bool isMem;
    if(classMembers != null) {
      isMem = classMembers.containsKey(user_id);
    }else{
      isMem = false;
    }
    return isMem;
  }




   _joinClass(classId) async{
    GoogleSignIn userInfo = login.getUser();

    DatabaseReference classMembers = FirebaseDatabase.instance.reference().child("classes").child(classId).child("members");

    // Needs to be sent to both classes and members because
    // it is a two way relation and makes it much easier to query both


    // push to classes
    await classMembers.child(userInfo.currentUser.id).set({
      'user_id' : userInfo.currentUser.id,
      'username' : userInfo.currentUser.displayName,
      'photo_url' : userInfo.currentUser.photoUrl
    });

    // push to members
    await reference.child(userInfo.currentUser.id).child(classId).set({
      'name': snapshot.value['name'],
      'code': snapshot.value['code'],
      'professor': snapshot.value['professor'],
      'members' : snapshot.value['members']
    });


    //set state for the check mark system
    setState(() {
        userIsMember = true;
    });
  }


  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animation, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child:
        new ListTile(
            title: new Text(
                snapshot.value['name'],
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead
            ),
            leading: new Icon(Icons.school),
            subtitle: new Text(
                snapshot.value['code'] + " - " + snapshot.value['professor']
            ),
            trailing: new IconButton(
                icon: userIsMember ? new Icon(Icons.check, color: Colors.green): new Icon(Icons.add),
                onPressed: userIsMember ? null : ()=>_joinClass(snapshot.key)

            ),

        )


    );
  }
}

