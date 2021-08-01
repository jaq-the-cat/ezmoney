import 'package:sqflite/sqflite.dart';
import 'dart:math';

final rng = new Random();

DateTime _toSimple(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day);
}

void populateWithTestData(Database db) async {
  _getMonthlyInfo().forEach((e) => addStatic(db, e['dt'], e['money']));
  _getYearlyInfo().forEach((e) => addStatic(db, e['dt'], e['money']));
  _getAllTimeInfo().forEach((e) => addStatic(db, e['dt'], e['money']));
}

Future<void> addStatic(Database db, int dt, double money) async {
  db.insert(
    'mone',
    {'dt': dt, 'money': money},
  );
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);
DateTime toYear(DateTime dt) => DateTime(dt.year);

List<Map<String, dynamic>> _getMonthlyInfo() {
  return List.generate(DateTime.now().day, (i) {
    print(i);
    return{
      'dt': _toSimple(DateTime.now().subtract(Duration(days: i))).millisecondsSinceEpoch,
      'money': (rng.nextDouble() - 0.5) * 100
    };
  });
}

List<Map<String, dynamic>> _getYearlyInfo() {
  return List.generate(DateTime.now().month, (i) {
    return {
      'dt': toMonth(DateTime.now().subtract(Duration(days: 31*i))).millisecondsSinceEpoch,
      'money': (rng.nextDouble() - 0.5) * 100
    };
  });
}

List<Map<String, dynamic>> _getAllTimeInfo() {
  return List.generate(15, (i) => {
    'dt': toYear(DateTime.now().subtract(Duration(days: 365*i))).millisecondsSinceEpoch,
    'money': (rng.nextDouble() - 0.5) * 100
  });
}
