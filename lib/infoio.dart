import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

final rng = new Random();

DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
String _today() => _toSimple(DateTime.now()).toIso8601String();

Future<void> addInfo(double money) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double old = prefs.getDouble(_today()) ?? 0.0;
    prefs.setDouble(_today(), old + money);
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
