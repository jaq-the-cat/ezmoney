import 'package:flutter/material.dart';
import 'infoio.dart';
import 'util.dart';

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

abstract class RecursiveNetList extends StatefulWidget {
  final DateTime dt;
  final String? appBarTitle;
  final noItemLongPress;
  final noItemTap;
  final Function()? refresh;
  RecursiveNetList(this.dt, this.appBarTitle, {this.noItemTap=false, this.noItemLongPress=false, this.refresh});

  RecursiveNetList? _nextNode(DateTime dt);

  String _dtToString(DateTime dt);

  Future<List<Map<String, dynamic>>> getInfo();

  void _onItemLongPress(BuildContext context, int mse) {}

  void _onItemTap(BuildContext context, int mse) {
  Widget? e = _nextNode(DateTime.fromMillisecondsSinceEpoch(mse));
  if (e != null)
    Navigator.push(context, new MaterialPageRoute(builder: (context) => e));
  }

  Widget moneyItem({required double net, required DateTime mdt, Function()? onTap, Function()? onLongPress}) {
    return Padding(
      padding: EdgeInsets.only(bottom: margin),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(toMoneyString(net),
                  style: TextStyle(fontSize: fontSize)),
              ),
              Row(
                children: <Widget>[
                  Text(_dtToString(mdt),
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

  Widget genList(Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return Container(
          child: ListView(
            padding: EdgeInsets.only(top: margin, left: margin, right: margin),
            children: List<Widget>.from(snapshot.data!.map((row) =>
              moneyItem(
                net: row["money"],
                mdt: DateTime.fromMillisecondsSinceEpoch(row["dt"]),
                onTap: noItemTap ? null : () => _onItemTap(context, row["dt"]),
                onLongPress: noItemLongPress ? null : () => _onItemLongPress(context, row["dt"]),
              )
            )),
          )
        );
      },
    );
  }

  @override
  _RecursiveNetListState createState() => _RecursiveNetListState();
}

class _RecursiveNetListState extends State<RecursiveNetList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarTitle == null ? null : AppBar(title: Text(widget.appBarTitle!)),
      body: widget.genList(widget.getInfo(),
    ));
  }
}
class MonthNetList extends RecursiveNetList {
  MonthNetList(DateTime dt, String? appBarTitle) : super(dt, appBarTitle, noItemTap: true);

  @override
  String _dtToString(DateTime dt) => _toDateString(dt);

  @override
  Future<List<Map<String, dynamic>>> getInfo() => getMonthlyInfo(dt);

  @override
  RecursiveNetList? _nextNode(DateTime dt) => null;

  @override
  void _onItemTap(BuildContext context, int mse) => null;

  @override
  void _onItemLongPress(BuildContext context, int mse) {
    String d = DateTime.fromMillisecondsSinceEpoch(mse).toString();
    removeDialog(context, "all data on ${d.substring(0, 10)}").then((r) {
      if (r!) removeStatic(mse);
    });
  }
}
class YearNetList extends RecursiveNetList {
  YearNetList(DateTime dt, String? appBarTitle) : super(dt, appBarTitle, noItemLongPress: true);

  @override
  String _dtToString(DateTime dt) => _toMonthString(dt);

  @override
  Future<List<Map<String, dynamic>>> getInfo() => getYearlyInfo(dt);

  @override
  RecursiveNetList _nextNode(DateTime dt) => MonthNetList(dt, _toMonthString(dt));
}
class AllTimeNetList extends RecursiveNetList {
  AllTimeNetList(DateTime dt) : super(dt, null, noItemLongPress: true);

  @override
  String _dtToString(DateTime dt) => _toYearString(dt);

  @override
  Future<List<Map<String, dynamic>>> getInfo() => getAllTimeInfo();

  @override
  RecursiveNetList _nextNode(DateTime dt) => YearNetList(dt, _toYearString(dt));
}
