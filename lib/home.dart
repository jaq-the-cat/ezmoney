import 'package:flutter/material.dart';
import 'infoio.dart';

class HomePage extends StatefulWidget {
    @override
    HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

    String toMoneyString(double net) {
        String snet = net.toStringAsFixed(2);
        if (snet.startsWith('-'))
            snet = snet.substring(1, snet.length);
        return snet;
    }

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
                    return ListView(
                        children: List<Widget>.from(snapshot.data.map((net) {
                            return Container(
                                margin: EdgeInsets.all(15),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(toMoneyString(net)),
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            color: net >= 0 ? Colors.green : Colors.red,
                                            child: Icon(net >= 0 ? Icons.add : Icons.remove),
                                        )
                                    ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: net >= 0
                                        ? Colors.green
                                        : Colors.red
                                    ),
                                ),
                            );
                        })),
                    );
                },
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
