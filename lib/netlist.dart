import 'package:flutter/material.dart';

String _toDateString(DateTime dt) =>
    dt.toString().split(' ').first.replaceAll('-', '/');

String _toMoneyString(double net) {
    String snet = net.toStringAsFixed(2);
    if (snet.startsWith('-')) {
        snet = snet.substring(1, snet.length);
        snet = "-\$" + snet;
    } else {
        snet = "\$" + snet;
    }
    return snet;
}

Widget netListFromInfo(Future info) => FutureBuilder(
    future: info,
    builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return netList(snapshot.data);
    },
);

Widget netList(List<List<dynamic>> list) {
    return ListView(
        children: List<Widget>.from(list.map((pair) =>
            moneyItem(net: pair.last, date: pair.first)
        )),
    );
}

Widget moneyItem({double net, DateTime date}) {
    final double fontSize = 16.0;
    final double margin = 10.0;
    return Container(
        margin: EdgeInsets.only(
            left: margin, top: margin, right: margin),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _toMoneyString(net),
                        style: TextStyle(
                            fontSize: fontSize,
                        )
                    ),
                ),
                Row(
                    children: <Widget>[
                        Text(
                            _toDateString(date),
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
}
