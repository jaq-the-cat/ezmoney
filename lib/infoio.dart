Future<List<List<dynamic>>> getDailyInfo([int limit = 25]) async {
    return [
        [DateTime.now().add(Duration(days: 0)), 10.5],
        [DateTime.now().add(Duration(days: 1)), 0.0],
        [DateTime.now().add(Duration(days: 2)), -1.2],
        [DateTime.now().add(Duration(days: 3)), 20.0],
        [DateTime.now().add(Duration(days: 4)), 2000.0],
    ];
}

DateTime toMonth(DateTime dt) => DateTime(dt.year, dt.month);

Future<List<List<dynamic>>> getMonthlyInfo([int limit = 25]) async {
    return [
        [toMonth(DateTime.now()), 10.5],
        [toMonth(DateTime.now()), 0.0],
        [toMonth(DateTime.now()), -1.2],
        [toMonth(DateTime.now()), 20.0],
        [toMonth(DateTime.now()), 2000.0],
    ];
}
