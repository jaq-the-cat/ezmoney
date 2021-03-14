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
        return Scaffold(
            appBar: AppBar(
                title: Text("EZMONEY"),
            ),
            body: FutureBuilder(
                future: getInfo(),
                builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return netList(snapshot.data);
                },
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
            ]
        );
    }
}
