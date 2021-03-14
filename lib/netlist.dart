import 'package:flutter/material.dart';
import 'infoio.dart';

final double _fontSize = 16.0;
final double _margin = 10.0;

final _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
];

enum NetListTypes {
    Day,
    Month,
}

String _toDateString(DateTime dt) => dt.toString().split(' ').first.replaceAll('-', '/');

String _toMonthString(DateTime dt) => _months[dt.month-1];

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

Widget genNetList({bool isDay = true}) {
    return FutureBuilder(
        future: isDay ? getMonthlyInfo() : getYearlyInfo(),
        builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Container(
                margin: EdgeInsets.only(top: _margin),
                child: ListView(
                    children: List<Widget>.from(snapshot.data.map((pair) =>
                        moneyItem(net: pair.last,
                            date: isDay ? _toDateString(pair.first) : _toMonthString(pair.first))
                    )),
                )
            );
        },
    );
}

Widget moneyItem({double net, String date}) {
    return Container(
        margin: EdgeInsets.only(
            left: _margin, bottom: _margin, right: _margin),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _toMoneyString(net),
                        style: TextStyle(
                            fontSize: _fontSize,
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
}
