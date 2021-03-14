import 'dart:math';

final rng = new Random();

Future<List<List<dynamic>>> getMonthlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [DateTime.now().add(Duration(days: i)), (rng.nextDouble() - 0.5) * 100]);
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);
DateTime toYear(DateTime dt) => DateTime(dt.year);

Future<List<List<dynamic>>> getYearlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [toMonth(DateTime.now().add(Duration(days: 31*i))), (rng.nextDouble() - 0.5) * 100]);
}

Future<List<List<dynamic>>> getAllTimeInfo() async {
    return List.generate(rng.nextInt(10), (i) =>
        [toYear(DateTime.now().subtract(Duration(days: 365))), (rng.nextDouble() - 0.5) * 100]);
}
