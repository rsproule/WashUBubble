import 'package:flutter/material.dart';
import './MyClassesView.dart' as myclass;
import './AllClassesView.dart' as allclasses;
import './AddClassForm.dart' as addclass;

class SchoolPage extends StatefulWidget {
  @override
  SchoolPageState createState() => new SchoolPageState();
}


class SchoolPageState extends State<SchoolPage>
    with SingleTickerProviderStateMixin {

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


  TabController _tabController;

  List<Tab> myTabs = [
    new Tab(icon: new Icon(Icons.person), text: "My Classes"),
    new Tab(icon: new Icon(Icons.all_inclusive), text: "All Classes"),
    new Tab(icon: new Icon(Icons.add_to_photos), text: "Add Class"),
  ];


  @override
  Widget build(BuildContext context) {
    return new Column(
        children: <Widget>[
          new TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.blueGrey,
              indicatorColor: Colors.blue,
              controller: _tabController,
              tabs: myTabs
          ),
          new Expanded(
              child: new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    new myclass.MyClassesView(),
                    new allclasses.AllClassesView(),
                    new addclass.AddClassForm(),

                  ]
              )
          )

        ]

    );
  }

}