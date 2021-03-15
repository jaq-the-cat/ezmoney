import 'package:flutter/material.dart';
import 'netlist.dart';
import 'infoio.dart';

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
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _moneyDialog(context).then((v) => setState(() {})),
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
                                            onPressed: () {
                                                if (ctrl.text.isNotEmpty)
                                                    addInfo(double.parse(ctrl.text));
                                                Navigator.of(context).pop(ctrl.text);
                                            },
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

