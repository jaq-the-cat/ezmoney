import 'package:sqflite/sqflite.dart';
import 'dart:math';

final rng = new Random();

DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);

void populateWithTestData(Database db) async {
    (await _getMonthlyInfo()).forEach((e) => addInfo(db, e['dt'], e['money']));
    (await _getYearlyInfo()).forEach((e) => addInfo(db, e['dt'], e['money']));
    (await _getAllTimeInfo()).forEach((e) => addInfo(db, e['dt'], e['money']));
}

Future<void> addInfo(Database db, int dt, double money) async {
    db.insert(
        'mone',
        {'dt': dt, 'money': money},
        conflictAlgorithm:  ConflictAlgorithm.replace,
    );
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);
DateTime toYear(DateTime dt) => DateTime(dt.year);

Future<List<Map<String, dynamic>>> _getMonthlyInfo() async {
    return List.generate(rng.nextInt(31), (i) => {
        'dt': _toSimple(DateTime.now().subtract(Duration(days: i))).millisecondsSinceEpoch,
        'money': (rng.nextDouble() - 0.5) * 100
    });
}

Future<List<Map<String, dynamic>>> _getYearlyInfo() async {
    return List.generate(DateTime.now().month, (i) {
        return {
            'dt': toMonth(DateTime.now().subtract(Duration(days: 31*i))).millisecondsSinceEpoch,
            'money': (rng.nextDouble() - 0.5) * 100
        };
    });
}

Future<List<Map<String, dynamic>>> _getAllTimeInfo() async {
    return List.generate(15, (i) => {
        'dt': toYear(DateTime.now().subtract(Duration(days: 365*i))).millisecondsSinceEpoch,
        'money': (rng.nextDouble() - 0.5) * 100
    });
}
