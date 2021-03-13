import 'package:flutter/material.dart';

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
            body: Padding(
                padding: EdgeInsets.all(15),
                child: Container(),
            ),
            persistentFooterButtons: <Widget>[
                IconButton(
                    icon: Icon(Icons.remove),
                    color: Colors.deepOrange,
                    onPressed: () {},
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.deepOrange,
                    onPressed: () {},
                ),
            ]
        );
    }
}
