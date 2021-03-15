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

void initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final db = await _database;
    await clearDatabase();
    populateWithTestData(db);
}

int _firstDayOfMonth(DateTime dt) =>
    DateTime(dt.year, dt.month, 1).millisecondsSinceEpoch;

int _firstDayOfYear(DateTime dt) =>
    DateTime(dt.year).millisecondsSinceEpoch;

DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);

DateTime _today() => _toSimple(DateTime.now());

Future<void> addInfo(double money) async {
    final Database db = await _database;
    final int mse = _today().millisecondsSinceEpoch;
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

Future<List<Map<String, dynamic>>> _doMoneQuery([int timestamp]) async {
    final Database db = await _database;
    return List<Map<String, dynamic>>.from(await db.query('mone',
        where: '"dt" >= ?',
        whereArgs: [timestamp ?? 0],
    ));
}

Future<List<Map<String, dynamic>>> getMonthlyInfo() async {
    return _doMoneQuery(_firstDayOfMonth(DateTime.now()));
}

Future<List<Map<String, dynamic>>> getYearlyInfo() async {
    List<Map<String, dynamic>> proc = [];
    final r = await _doMoneQuery(_firstDayOfYear(DateTime.now()));
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
