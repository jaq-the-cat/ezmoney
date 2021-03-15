import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'testdata.dart';
import 'package:path/path.dart' as path;

final Future<Database> _database = (() async => openDatabase(
    path.join(await getDatabasesPath(), 'data.db'),
    onCreate: (db, version) => db.execute("CREATE TABLE mone(dt INTEGER, money REAL)"),
    version:  1,
))();

void initDatabase() {
    WidgetsFlutterBinding.ensureInitialized();
    populateWithTestData(_database);
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
        where: '"dt" > ?',
        whereArgs: [timestamp ?? 0],
    ));
}

Future<List<Map<String, dynamic>>> getMonthlyInfo() async {
    return _doMoneQuery(_firstDayOfMonth(DateTime.now()));
}

Future<List<Map<String, dynamic>>> getYearlyInfo() async {
    return _doMoneQuery(_firstDayOfYear(DateTime.now()));
}

Future<List<Map<String, dynamic>>> getAllTimeInfo() async {
    return _doMoneQuery();
}
