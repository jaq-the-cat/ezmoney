import 'package:flutter/material.dart';
import 'util.dart';

class RoutineMone extends StatelessWidget {
  RoutineMone();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Icon(Icons.calendar_today),
          SizedBox(width: 8),
          Text("Persistent"),
        ],
      )),
      body: Padding(
        padding: EdgeInsets.all(margin),
        child: Column(
          children: [
            _Item("Daily", 0, (double d) {}),
            _Item("Weekly", 0, (double d) {}),
            _Item("Monthly", 0, (double d) {}),
            _Item("Yearly", 0, (double d) {}),
          ]
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String name;
  final double mone;
  final Function(double) onAdd;
  _Item(this.name, this.mone, this.onAdd);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: fontSize+3, color: Colors.white60)),
          SizedBox(height: 5),
          InkWell(
            onTap: () {
              moneyDialog(context).then((v) {
                onAdd(double.tryParse(v) ?? 0.0);
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(margin),
                    child: Text(mone.toString(), style:  TextStyle(fontSize: fontSize)),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.deepOrange,
                    child: Icon(Icons.attach_money),
                  )
                ]
              ),
              decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange))
            ),
          ),
        ],
      )
    );
  }
}
