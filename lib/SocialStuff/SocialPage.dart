import 'package:flutter/material.dart';


class SocialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color.fromRGBO(210, 213, 219, 1.0),
      body: new Center(
          child: new Container(
              padding: const EdgeInsets.only(top: 250.0),
              child: new Center(
                  child: new Column(
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new Divider(color: Colors.transparent),
                        new Text("Loading nothing...")
                      ]
                  )
              )
          )
      ),
    );
  }
}