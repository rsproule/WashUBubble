import 'package:flutter/material.dart';
import './PostNewEventForm.dart' as add;
import './UpcomingPage.dart' as upcoming;
import './StarredPage.dart' as star;


class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => new _JobsPageState();
}

class _JobsPageState extends State<JobsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> myTabs = [
    new Tab(icon: new Icon(Icons.event), text: "Upcoming"),
    new Tab(icon: new Icon(Icons.star), text: "Starred"),
//    new Tab(icon: new Icon(Icons.add_box), text: "Add an Event"),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        backgroundColor: new Color.fromRGBO(210, 213, 219, 1.0),

        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new add.NewEventForm();
                  }
              )
              );
            }
        ),


        body: new Column(
            children: <Widget>[
              new TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.blueGrey,
                  indicatorColor: Colors.blue,
                  controller: _tabController,
                  tabs: myTabs
              ),
              new Expanded(
                child:
                new TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      new upcoming.UpcomingPage(),
                      new star.StarredEventsPage(),
                    ]
                ),
              ),


            ]

        )
    );
  }
}

