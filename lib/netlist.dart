import 'package:flutter/material.dart';
import 'infoio.dart';

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

abstract class RecursiveNetList extends StatelessWidget {
  final DateTime dt;
  final String appBarTitle;
  RecursiveNetList(this.dt, this.appBarTitle);

  RecursiveNetList _nextNode(DateTime dt);
  String _dtToString();
  Future _getInfo();

  void _onItemTap(BuildContext context, DateTime dt) =>
    Navigator.push(context, new MaterialPageRoute(builder: (context) => _nextNode(dt)));

  Widget moneyItem({double net, DateTime dt, Function() onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: _margin),
      child: InkWell(
        onTap: onTap,
        child: Container(
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
                  Text(_dtToString(),
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
        ),
      ),
    );
  }

  Widget _genList(Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return Container(
          margin: EdgeInsets.only(top: _margin, left: _margin, right: _margin),
          child: ListView(
            children: List<Widget>.from(snapshot.data.map((row) =>
              moneyItem(
                net: row["money"],
                dt: DateTime.fromMillisecondsSinceEpoch(row["dt"]),
                onTap: () => _onItemTap(context, dt),
              )
            )),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle == null ? null : AppBar(title: Text(appBarTitle)),
      body: _genList(_getInfo(),
    ));
  }
}
class MonthNetList extends RecursiveNetList {
  MonthNetList(DateTime dt, String appBarTitle) : super(dt, appBarTitle);

  @override
  String _dtToString() => _toDateString(dt);

  @override
  Future _getInfo() => getMonthlyInfo();

  @override
  RecursiveNetList _nextNode(DateTime dt) => null;

  @override
  void _onItemTap(BuildContext context, DateTime dt) => null;
}
class YearNetList extends RecursiveNetList {
  YearNetList(DateTime dt, String appBarTitle) : super(dt, appBarTitle);

  @override
  String _dtToString() => _toMonthString(dt);

  @override
  Future _getInfo() => getYearlyInfo();

  @override
  RecursiveNetList _nextNode(DateTime dt) => MonthNetList(dt, _toMonthString(dt));
}
class AllTimeNetList extends RecursiveNetList {
  AllTimeNetList(DateTime dt) : super(dt, null);

  @override
  String _dtToString() => _toYearString(dt);

  @override
  Future _getInfo() => getAllTimeInfo();

  @override
  RecursiveNetList _nextNode(DateTime dt) => YearNetList(dt, _toYearString(dt));
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
