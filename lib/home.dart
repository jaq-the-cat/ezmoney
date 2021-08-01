import 'package:flutter/material.dart';
import 'netlist.dart';
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
          title: Text("EZMONEY"),
          bottom: TabBar(
            tabs: List<Widget>.from(tabs.map((t) => t.first)),
          ),
        ),
        body: TabBarView(
          children: List<Widget>.from(tabs.map((t) => t.last)),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _moneyDialog(context).then((v) {
            if (v != null && double.tryParse(v) != null)
            addStatic(double.parse(v), today()).then((_) {
              setState(() => {});
            });
          })
        ),
      ),
    );
  }
}

Future<String> _moneyDialog(BuildContext context) {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: ctrl,
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ),
                    fillColor: Colors.deepOrange,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text("CANCEL"),
                      onPressed: () => Navigator.of(context).pop(""),
                    ),
                    TextButton(
                      child: Text("ADD"),
                      onPressed: () => Navigator.of(context).pop(ctrl.text),
                    ),
                  ]
                )
              ]
            ),
          ],
        ),
      );
    }
  );
}

