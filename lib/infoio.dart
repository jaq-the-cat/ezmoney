import 'dart:math';

final rng = new Random();

Future<List<List<dynamic>>> getMonthlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [DateTime.now().add(Duration(days: i)), (rng.nextDouble() - 0.5) * 100]);
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);

Future<List<List<dynamic>>> getYearlyInfo() async {
    return List.generate(rng.nextInt(31), (i) =>
        [toMonth(DateTime.now().add(Duration(days: 31*i))), (rng.nextDouble() - 0.5) * 100]);
}
