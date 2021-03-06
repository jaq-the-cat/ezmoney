import 'package:flutter/material.dart';
import 'infoio.dart';
import 'home.dart';

void main() async {
  await initDatabase();
  await doRoutineMone();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZMONEY',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
