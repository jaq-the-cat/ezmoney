import 'package:flutter/material.dart';
import 'infoio.dart';
import 'util.dart';

class RoutineMone extends StatefulWidget {
  RoutineMone();

  @override
  _RoutineMoneState createState() => _RoutineMoneState();
}

class _RoutineMoneState extends State<RoutineMone> {
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
        child: FutureBuilder(
          future: getRoutineMones(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Column(
              children: [
                _Item("Daily", snapshot.data["daily"] ?? 0, (double d) => setState(() { setRoutineMone("daily", d); })),
                _Item("Weekly", snapshot.data["weekly"] ?? 0,  (double d) => setState(() { setRoutineMone("weekly", d); })),
                _Item("Monthly", snapshot.data["monthly"] ?? 0,  (double d) => setState(() { setRoutineMone("monthly", d); })),
                _Item("Yearly", snapshot.data["yearly"] ?? 0,  (double d) => setState(() { setRoutineMone("yearly", d); })),
              ]
            );
          }
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
                double vd = double.tryParse(v);
                if (vd != null)
                  onAdd(vd);
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(margin),
                    child: Text(toMoneyString(mone), style:  TextStyle(fontSize: fontSize)),
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
