import 'package:flutter/material.dart';
import 'infoio.dart';

enum NLType {
  Month,
  Year,
  AllTime,
}

final double _fontSize = 16.0;
final double _margin = 10.0;

String _toDateString(DateTime dt) => dt.toString().split(' ').first.replaceAll('-', '/');

String _toMonthString(DateTime dt) => _months[dt.month-1];

String _toYearString(DateTime dt) => dt.toString().split('-').first;

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

class RecursiveNetList extends StatelessWidget {

  final int dt;
  final NLType type;

  RecursiveNetList(this.dt, this.type);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_dtToString(type,
        DateTime.fromMillisecondsSinceEpoch(dt)))),
      body: genNetList(_nextType(type), _typeToInfo(type),
        onClick: (dt) {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => RecursiveNetList(dt, _nextType(type))));
        }),
    );
  }
}

Widget genNetList(NLType type, Future<List<Map<String, dynamic>>> future, {Function(int dt) onClick}) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Container();
      return Container(
        margin: EdgeInsets.only(top: _margin),
        child: ListView(
          children: List<Widget>.from(snapshot.data.map((row) =>
            moneyItem(net: row["money"],
              date: _dtToString(type,
                DateTime.fromMillisecondsSinceEpoch(row["dt"])))
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
          child: Text(_toMoneyString(net),
            style: TextStyle(fontSize: _fontSize)),
        ),
        Row(
          children: <Widget>[
            Text(date,
              style: TextStyle(color:  Colors.white24)),
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
    decoration: BoxDecoration(border: Border.all(color: net >= 0
          ? Colors.green : Colors.red)),
  );
}


Future _typeToInfo(NLType type) {
  switch(type) {
    case NLType.Month:
      return getMonthlyInfo();
    case NLType.Year:
      return getYearlyInfo();
    case NLType.AllTime:
      return getAllTimeInfo();
  }
  return null;
}

String _dtToString(NLType type, DateTime dt) {
  switch(type) {
    case NLType.Month:
      return _toDateString(dt);
    case NLType.Year:
      return _toMonthString(dt);
    case NLType.AllTime:
      return _toYearString(dt);
  }
  return null;
}

String _toMoneyString(double net) {
  String snet = net.toStringAsFixed(2);
  if (snet.startsWith('-')) {
    snet = snet.substring(1, snet.length);
    snet = "-¤" + snet;
  } else {
    snet = "¤" + snet;
  }
  return snet;
}

NLType _nextType(NLType type) {
  switch (type) {
    case NLType.AllTime:
      return NLType.Year;
    case NLType.Year:
      return NLType.Month;
    case NLType.Month:
      return null;
  }
  return null;
}
