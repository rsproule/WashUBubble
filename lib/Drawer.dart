import 'package:flutter/material.dart';
import './main.dart' as main;
import './Drawer.dart' as _Drawer;


class MainDrawer extends StatefulWidget {
  String currpage = "";
  MainDrawer(String cp){
    this.currpage = cp;
  }

  @override
  MainDrawerState createState() => new MainDrawerState(currpage);
}

class MainDrawerState extends State<MainDrawer> {
  String currentPage = "";
  MainDrawerState(String cp){
    this.currentPage = cp;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(

        child: new Column(

            children: <Widget>[

              new Padding(padding: new EdgeInsets.all(10.0)),
              new DrawerHeader(
                padding: new EdgeInsets.all(50.0),
                child: new Text(
                    "WU Bubble",
                    textScaleFactor: 2.0,
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: Colors.blue)),


              ),
              new ListTile(
                  leading: new Icon(Icons.home),
                  title: new Text("Home"),
                  selected: currentPage == "Home",
                  onTap: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new main.App();
                        }
                    )
                    );
                  }


              ),
              new ListTile(
                  leading: new Icon(Icons.person),
                  title: new Text("Profile"),
                  selected: currentPage == "Profile",
                  onTap: () {

                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new Scaffold(
                            appBar: new AppBar(title: new Text("Profile")),
                            drawer: new _Drawer.MainDrawer("Profile"),
                          );
                        }
                    )
                    );
                  }


              ),
              new ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text("Settings"),
                  selected: currentPage == "Settings",
                  onTap: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new Scaffold(
                              drawer: new _Drawer.MainDrawer("Settings"),
                              appBar: new AppBar(title:  new Text("Settings"))
                          );
                        }
                    )
                    );
                  }


              ),

              new AboutListTile(icon: new Icon(Icons.info),
                  applicationName: "WU Bubble",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "Created by Ryan Sproule"
              ),



            ]
        )
    );
  }
}