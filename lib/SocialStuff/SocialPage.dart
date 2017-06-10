import 'package:flutter/material.dart';
import './Post.dart' as post;

class SocialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color.fromRGBO(210, 213, 219, 1.0),
      body: new Center(
          child: new RefreshIndicator(
            // padding: const EdgeInsets.only(top: 250.0),
              child: new ListView(
                  children: <Widget>[
                    new post.Post(),
                    new post.Post(),
                    new post.Post(),
                    new post.Post(),
                    new post.Post(),


                  ]
              ),
              onRefresh: () {}
          )
      ),
    );
  }
}