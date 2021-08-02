import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'testdata.dart';
import 'package:path/path.dart' as path;

final Future<Database> _database = (() async => openDatabase(
  path.join(await getDatabasesPath(), 'data.db'),
  onCreate: (db, version) => db.execute("CREATE TABLE mone(dt INTEGER, money REAL)"),
  version:  1,
))();

Future<void> clearDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await _database;
  return db.execute('DELETE FROM mone');
}

Future<void> initDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearDatabase();
  populateWithTestData();
}

DateTime _firstDayOfMonth(DateTime dt) =>
  DateTime(dt.year, dt.month, 1);

DateTime _lastDayOfMonth(DateTime dt) {
  int month = dt.month;
  month++;
  if (month > 12)
    month = 1;
  return DateTime(dt.year, month, 1).add(Duration(hours: -24));
}

DateTime _firstDayOfYear(DateTime dt) =>
  DateTime(dt.year);

DateTime _lastDayOfYear(DateTime dt) =>
  DateTime(dt.year+1).add(Duration(hours: -24));

Future<void> addStatic(double money, DateTime dt) async {
  final Database db = await _database;
  final int mse = dt.millisecondsSinceEpoch;
  print("$mse : $money");
  final queryResult = await db.query('mone', where: '"dt" == ?', whereArgs: [mse]);
  if (queryResult.isEmpty) {
    db.insert(
      'mone',
      {'dt': mse, 'money': money},
      conflictAlgorithm:  ConflictAlgorithm.replace,
    );
  } else {
    double pmoney = queryResult.single['money'];
    db.update(
      'mone',
      {'money': pmoney + money},
      where: '"dt" == ?',
      whereArgs: [mse],
      conflictAlgorithm:  ConflictAlgorithm.replace,
    );
  }
}

Future<List<Map<String, dynamic>>> _doMoneQuery([int starttimestamp, int endtimestamp]) async {
  final Database db = await _database;
  return List<Map<String, dynamic>>.from(await db.query('mone',
    where: '"dt" >= ? AND "dt" < ?',
    whereArgs: [starttimestamp ?? 0, endtimestamp ?? DateTime.now().millisecondsSinceEpoch],
  ));
}

Future<List<Map<String, dynamic>>> getMonthlyInfo(DateTime month) async {
  return _doMoneQuery(
    _firstDayOfMonth(month).millisecondsSinceEpoch,
    _lastDayOfMonth(month).millisecondsSinceEpoch);
}

Future<List<Map<String, dynamic>>> getYearlyInfo(DateTime year) async {
  List<Map<String, dynamic>> proc = [];
  final r = await _doMoneQuery(
    _firstDayOfYear(year).millisecondsSinceEpoch,
    _lastDayOfYear(year).millisecondsSinceEpoch);
  Map<int, double> monthData = {};
  r.forEach((row) {
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(row['dt']);
    if (monthData.containsKey(dt.month))
      monthData[dt.month] += row['money'];
    else
      monthData[dt.month] = row['money'];
  });
  monthData.forEach((month, money) {
    proc.add({
      'dt': DateTime(DateTime.now().year, month, 1).millisecondsSinceEpoch,
      'money': money,
    });
  });
  return proc;
}

Future<List<Map<String, dynamic>>> getAllTimeInfo() async {
  List<Map<String, dynamic>> proc = [];
  final r = await _doMoneQuery();
  Map<int, double> yearData = {};
  r.forEach((row) {
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(row['dt']);
    if (yearData.containsKey(dt.year))
      yearData[dt.year] += row['money'];
    else
      yearData[dt.year] = row['money'];
  });
  yearData.forEach((year, money) {
    proc.add({
      'dt': DateTime(year, 1, 1).millisecondsSinceEpoch,
      'money': money,
    });
  });
  return proc;
}
