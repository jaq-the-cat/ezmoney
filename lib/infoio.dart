import 'dart:math';

final rng = new Random();

DateTime _firstDayOfMonth(DateTime dt) =>
    DateTime(dt.year, dt.month, 1);

DateTime _firstDayOfYear(DateTime dt) =>
    DateTime(dt.year);



DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
String _today() => _toSimple(DateTime.now()).toIso8601String();

Future<void> addInfo(double money) async {
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
