import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  SearchInputState createState() => new SearchInputState();
}

class SearchInputState extends State<SearchView> {
  String searchVal = '';

  @override
  Widget build(BuildContext context) {
    return new Container(

        child:

        new TextField(
            decoration: new InputDecoration(
                icon: new Icon(Icons.search),
                hideDivider: true,
                hintText: "Search"
            )
        )


    );
  }
}