import 'package:flutter/material.dart';

final double fontSize = 16.0;
final double margin = 10.0;

DateTime toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
DateTime today() => toSimple(DateTime.now());

String toMoneyString(double net) {
  String snet = net.toStringAsFixed(2);
  if (snet.startsWith('-')) {
    snet = snet.substring(1, snet.length);
    snet = "-¤" + snet;
  } else {
    snet = "¤" + snet;
  }
  return snet;
}

Future<bool?> removeDialog(BuildContext context, String thing) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $thing'),
        content: SingleChildScrollView(
          child: Text('Would you really like to delete $thing?'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    }
  );
}

Future<String?> moneyDialog(BuildContext context) {
  final ctrl = TextEditingController();
  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: ctrl,
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ),
                    fillColor: Colors.deepOrange,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: Text("CANCEL"),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                    TextButton(
                      child: Text("ADD"),
                      onPressed: () => Navigator.of(context).pop(ctrl.text),
                    ),
                  ]
                )
              ]
            ),
          ],
        ),
      );
    }
  );
}
