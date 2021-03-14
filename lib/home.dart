import 'package:flutter/material.dart';
import 'infoio.dart';
import 'netlist.dart';

class HomePage extends StatefulWidget {

    @override
    HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
    @override
    Widget build(BuildContext context) {
        final List<List<Widget>> tabs = [
            [Tab(icon: Icon(Icons.calendar_today)), netListFromInfo(getInfo(7))],
            [Tab(icon: Icon(Icons.calendar_today)), netListFromInfo(getInfo(30))],
            [Tab(icon: Icon(Icons.calendar_today)), netListFromInfo(getInfo(365))],
        ];
        return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
                appBar: AppBar(
                    title: Text("EZMONEY"),
                    bottom: TabBar(
                        tabs: List<Widget>.from(tabs.map((t) => t.first)),
                    ),
                ),
                body: TabBarView(
                    children: List<Widget>.from(tabs.map((t) => t.last)),
                ),
                persistentFooterButtons: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.deepOrange,
                        onPressed: () {},
                    ),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.deepOrange,
                        onPressed: () {},
                    ),
                ],
            ),
        );
    }
}
