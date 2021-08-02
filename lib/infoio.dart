import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'testdata.dart';
import 'util.dart';
import 'package:path/path.dart' as path;

class DMY {
  final int y, m, d;
  DMY(this.y, this.m, this.d);
}

final Future<Database> _database = (() async => openDatabase(
  path.join(await getDatabasesPath(), 'data.db'),
  onCreate: (db, version) => db.execute("CREATE TABLE mone(dt INTEGER, money REAL)"),
  version: 1,
))();

Future<void> clearDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await _database;
  db.execute('DELETE FROM mone');
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

Future<int> _getLastLogin() async {
  final prefs = await SharedPreferences.getInstance();
  int lldt = prefs.getInt('lldt');
  if (lldt == null)
    lldt = DateTime.now().millisecondsSinceEpoch;
  prefs.setInt('lldt', DateTime.now().millisecondsSinceEpoch);
  return lldt;
}

Future<Map<String, double>> getRoutineMones() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    "daily": prefs.getDouble("daily"),
    "weekly": prefs.getDouble("weekly"),
    "monthly": prefs.getDouble("monthly"),
    "yearly": prefs.getDouble("yearly"),
  };
}

Future<bool> setRoutineMone(String id, double mone) async {
  final prefs = await SharedPreferences.getInstance();
  if (['daily', 'weekly', 'monthly', 'yearly'].contains(id)) {
    prefs.setDouble(id, mone);
    return true;
  }
  return false;
}

Future<DMY> dmySinceLastLogin() async {
  DateTime now = today();
  DateTime then = DateTime.fromMillisecondsSinceEpoch(await _getLastLogin());
  int years = now.year - then.year;
  int months = now.month - then.month;
  int days = now.day - then.day;
  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (days < 0 ? 11 : 12);
  }
  if (days < 0) {
    final monthAgo = DateTime(now.year, now.month - 1, then.day);
    days = now.difference(monthAgo).inDays + 1;
  }

  return DMY(years, months, days);
}

Future<int> weeksSinceLastLogin() async {
  DateTime lldt = DateTime.fromMillisecondsSinceEpoch(await _getLastLogin());
  return (today().difference(lldt).inDays / 7).round();
}

Future<double> doRoutineMone() async {
  final prefs = await SharedPreferences.getInstance();
  double mone = 0.0;

  final weeks = await weeksSinceLastLogin();
  double weekly = prefs.getDouble("weekly") ?? 0;

  mone += weeks * weekly;

  final dmy = await dmySinceLastLogin();
  double daily = prefs.getDouble("daily") ?? 0;
  double monthly = prefs.getDouble("monthly") ?? 0;
  double yearly = prefs.getDouble("yearly") ?? 0;

  mone += dmy.d * daily;
  mone += dmy.m * monthly;
  mone += dmy.y * yearly;

  return mone;
}

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
      'dt': DateTime(year.year, month, 1).millisecondsSinceEpoch,
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
