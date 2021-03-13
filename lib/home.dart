import 'package:flutter/material.dart';
import 'infoio.dart';

class HomePage extends StatefulWidget {

    final double fontSize = 16.0;
    final double margin = 10.0;

    @override
    HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

    String toMoneyString(double net) {
        String snet = net.toStringAsFixed(2);
        if (snet.startsWith('-')) {
            snet = snet.substring(1, snet.length);
            snet = "-\$" + snet;
        } else {
            snet = "\$" + snet;
        }
        return snet;
    }

    String getDateString(DateTime dt) =>
        dt.toString().split(' ').first.replaceAll('-', '/');

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
                        children: List<Widget>.from(snapshot.data.map((pair) {
                            String date = getDateString(pair.first);
                            double net = pair.last;
                            return Container(
                                margin: EdgeInsets.only(
                                    left: widget.margin, top: widget.margin, right: widget.margin),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                toMoneyString(net),
                                                style: TextStyle(
                                                    fontSize:  widget.fontSize,
                                                )
                                            ),
                                        ),
                                        Row(
                                            children: <Widget>[
                                                Text(
                                                    date,
                                                    style: TextStyle(
                                                        color:  Colors.white24,
                                                    ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                    padding: EdgeInsets.all(10),
                                                    color: net >= 0 ? Colors.green : Colors.red,
                                                    child: Icon(net >= 0 ? Icons.add : Icons.remove),
                                                )
                                            ]
                                        ),
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
