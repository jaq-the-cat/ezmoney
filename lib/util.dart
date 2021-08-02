import 'package:flutter/material.dart';

final double fontSize = 16.0;
final double margin = 10.0;

DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
DateTime today() => _toSimple(DateTime.now());

Future<String> moneyDialog(BuildContext context) {
  final ctrl = TextEditingController();
  return showDialog<String>(
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
                      onPressed: () => Navigator.of(context).pop(""),
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
