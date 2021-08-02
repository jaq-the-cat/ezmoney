import 'package:flutter/material.dart';
import 'netlist.dart';
import 'routinemone.dart';
import 'infoio.dart';
import 'util.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> tabs = [
      [Tab(child: Text("Month")), MonthNetList(today(), null)],
      [Tab(child: Text("Year")), YearNetList(today(), null)],
      [Tab(child: Text("All Time")), AllTimeNetList(today())],
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: List<Widget>.from(tabs.map((t) => t.first)),
          ),
        ),
        body: TabBarView(
          children: List<Widget>.from(tabs.map((t) => t.last)),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              label: Text("Persistent"),
              icon: Icon(Icons.calendar_today),
              onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                RoutineMone())),
            ),
            SizedBox(width: 15),
            ElevatedButton.icon(
              label: Text("Manual"),
              icon: Icon(Icons.add),
              onPressed: () => moneyDialog(context).then((v) {
                double? vd = double.tryParse(v ?? "");
                if (vd != null)
                  addStatic(vd, today()).then((_) {
                    setState(() => {});
                  });
              })
            ),
          ],
        ),
      ),
    );
  }
}
