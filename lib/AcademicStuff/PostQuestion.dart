import 'package:flutter/material.dart';
import './loginStuff.dart' as login;
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PostQuestion extends StatefulWidget{

  String classKey;

  PostQuestion(String key){
    this.classKey = key;
  }
  @override
  PostQuestionState createState() => new PostQuestionState(classKey);
}

class PostQuestionState extends State<PostQuestion>{
  String classKey;

  PostQuestionState(String key){
    this.classKey = key;
  }


  final TextEditingController subjectController = new TextEditingController();
  final TextEditingController postController = new TextEditingController();
  final TextEditingController tagController = new TextEditingController();
  bool postIsAnonymous = false;


  Widget build (BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Post Question"),
        actions: <Widget> [
          new IconButton(
              icon: new Icon(Icons.info_outline),
              onPressed: _showInfoDialog
          )
        ]
      ),
      body: new ListView(
        children: <Widget> [
          new Divider(),
          new TextFormField(
              controller: subjectController,
              maxLines: 4,
              decoration: new InputDecoration(
                icon: new Icon(Icons.title),
                hintText: "Subject (i.e. 'Question about the lab')",
                hideDivider: true,
              )
          ),
          new Divider(),
          new Divider(color: Colors.transparent, height: 3.0),
          new TextFormField(
              controller: postController,
              maxLines: 20,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                hintText: "Question/Post (see info above for guidelines)",

                hideDivider: true,
              )
          ),

          new Divider(color: Colors.transparent),
          new Divider(),
          new TextFormField(
              controller: tagController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.book),
                hintText: "Tags (i.e. Homework 3, Midterm)",
                hideDivider: true,
              )
          ),
          new Divider(),



          new Column(
            children: <Widget> [
              new Text("Post Anonymously:", style: Theme.of(context).textTheme.subhead),

              new Switch(
                  value: this.postIsAnonymous,
                  onChanged: _switch
              ),
              new Divider(color: Colors.transparent),
              new Divider(color: Colors.transparent),

              new MaterialButton(
                  color: Colors.blue,
                  onPressed: () => _submitPost(this.classKey),
                  elevation: 10.0,

                  highlightColor: Colors.blueGrey,
                  highlightElevation: 5.0,
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.add, color: Colors.white),
                        new Text("Submit",
                            style: new TextStyle(color: Colors.white))
                      ]
                  )
              ),
            ]
          )


        ]
      )
    );
  }
  void _showInfoDialog() {
    showDialog(
        context: context,
        child: new Dialog(
          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 240.1,
                maxWidth: 50.1,
                minHeight: 100.0,
                minWidth: 30.0,
              ),
              child: new ListView(
                  children: <Widget> [
                    new Divider(color: Colors.transparent),
                    new Text("Posting Guidelines", textAlign: TextAlign.center, style: Theme.of(context).textTheme.title),
                    new ListTile(subtitle: new Text("1.  Never post anything that is or encourages breaking Wash U academic integrity policies."
                        , textAlign: TextAlign.left, style: Theme.of(context).textTheme.caption)
                    ),
                    new ListTile(dense: true, subtitle: new Text("2.  Search through existing questions before asking to make sure your question has not already been answered."
                        , textAlign: TextAlign.left, style: Theme.of(context).textTheme.caption)
                    ),
                    new ListTile(dense: true, subtitle: new Text("3. Give sufficient background and context for your question or post."
                        , textAlign: TextAlign.left, style: Theme.of(context).textTheme.caption)
                    ),


                    new Divider(color: Colors.transparent, height: 12.0),
                  ]
              )
          )
        )
    );
  }

   _submitPost(classKey) async{
    GoogleSignIn user = login.getUser();
    String subject = subjectController.text;
    String post = postController.text;
    String tag = tagController.text;
    String username  = this.postIsAnonymous ? "Anonymous" : user.currentUser.displayName;
    String userId    = this.postIsAnonymous ? null : user.currentUser.id;
    String userPhoto = this.postIsAnonymous ? null : user.currentUser.photoUrl;
    final reference = FirebaseDatabase.instance.reference().child('posts');


    showDialog(
      child: new Dialog(
          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.1,
                maxWidth: 10.1,
                minHeight: 100.0,
                minWidth: 10.0,
              ),
              child: new Column(
                  children: <Widget> [
                    new Divider(color: Colors.white),
                    new Text("Submitting Post...", textAlign: TextAlign.center),
                    new Divider(color: Colors.white, height: 12.0),
                    new CircularProgressIndicator()
                  ]
              )
          )
      ),
      context: context,

    );

    bool fieldsFilled = subject != "" && tag != "" && post != "";

    //get current time, sadly had to make a months array
    DateTime d = new DateTime.now();
    TimeOfDay t = new TimeOfDay.now();
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    String timestamp = months[d.month - 1] + " " + d.day.toString() + ", " +
        d.year.toString() + " " + t.toString();


     if(fieldsFilled) {
      //push to db
      await reference.child(classKey).push().set({
        'subject': subject,
        'post': post,
        'tag': tag,
        'timestamp' : timestamp,
        'username': username,
        'user_id': userId,
        'photo_url': userPhoto
      });
      _postSuccess(context);
    }else{
      _postFailed(context);
    }


  }

  void _postSuccess(context){
    Navigator.of(context).pop();
    subjectController.clear();
    postController.clear();
    tagController.clear();

    showDialog(
      child: new Dialog(

          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.1,
                maxWidth: 10.1,
                minHeight: 100.0,
                minWidth: 10.0,
              ),
              child: new Column(
                  children: <Widget> [
                    new Divider(color: Colors.white),
                    new Text("Submitted Successfully!", textAlign: TextAlign.center),
                    new Divider(color: Colors.white, height: 12.0),
                    new Icon(Icons.check, size: 50.0, color: Colors.green)
                  ]
              )
          )
      ),
      context: context,

    );
  }

  void _switch(bool value) {
    setState((){
      this.postIsAnonymous = value;
    });
  }

  void _postFailed(BuildContext context) {
    Navigator.of(context).pop();

    showDialog(
      child: new Dialog(

          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.1,
                maxWidth: 10.1,
                minHeight: 100.0,
                minWidth: 10.0,
              ),
              child: new Column(
                  children: <Widget> [
                    new Divider(color: Colors.white),
                    new Text("Submit Failed. All fields must be filled", textAlign: TextAlign.center),
                    new Divider(color: Colors.white, height: 12.0),
                    new Icon(Icons.cancel, size: 50.0, color: Colors.red)
                  ]
              )
          )
      ),
      context: context,

    );
  }
}

