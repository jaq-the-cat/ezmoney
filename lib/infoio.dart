import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

final rng = new Random();

final Future<Database> database = (() async => openDatabase(
    path.join(await getDatabasesPath(), 'data.db'),
    onCreate: (db, version) => db.execute("CREATE TABLE mone(dt INTEGER, money REAL)"),
    version:  1,
))();

DateTime _firstDayOfMonth(DateTime dt) =>
    DateTime(dt.year, dt.month, 1);

DateTime _firstDayOfYear(DateTime dt) =>
    DateTime(dt.year);

DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
DateTime _today() => _toSimple(DateTime.now());

Future<void> addInfo(double money) async {
    final Database db = await database;
    final int mse = _today().millisecondsSinceEpoch;
    final queryResult = await db.query('mone', where: '"dt" == ?', whereArgs: [mse]);
    if (queryResult.isNotEmpty) {
        db.insert(
            'mone',
            {'dt': mse, 'money': money},
            conflictAlgorithm:  ConflictAlgorithm.replace,
        );
    } else {
        db.update(
            'mone',
            {'money': int.parse(queryResult.single['money']) + money},
            where: '"dt" == ?',
            whereArgs: [mse],
            conflictAlgorithm:  ConflictAlgorithm.replace,
        );
}
}

Future<List<List<dynamic>>> getMonthlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [DateTime.now().subtract(Duration(days: i)), (rng.nextDouble() - 0.5) * 100]);
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);
DateTime toYear(DateTime dt) => DateTime(dt.year);

Future<List<List<dynamic>>> getYearlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [toMonth(DateTime.now().subtract(Duration(days: 31*i))), (rng.nextDouble() - 0.5) * 100]);
}

Future<List<List<dynamic>>> getAllTimeInfo() async {
    return List.generate(rng.nextInt(10), (i) =>
        [toYear(DateTime.now().subtract(Duration(days: 365*i))), (rng.nextDouble() - 0.5) * 100]);
}
