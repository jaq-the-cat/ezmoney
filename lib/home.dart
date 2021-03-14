import 'package:flutter/material.dart';
import 'netlist.dart';

class HomePage extends StatefulWidget {

    @override
    HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
    @override
    Widget build(BuildContext context) {
        final List<List<Widget>> tabs = [
            [Tab(child: Text("Month")), genNetList(NLType.Month)],
            [Tab(child: Text("Year")), genNetList(NLType.Year)],
            [Tab(child: Text("All Time")), genNetList(NLType.AllTime)],
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
