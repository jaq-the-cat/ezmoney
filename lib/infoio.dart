Future<List<List<dynamic>>> getInfo([int limit = 25]) async {
    return [
        [DateTime.now().add(Duration(days: 0)), 10.5],
        [DateTime.now().add(Duration(days: 1)), 0.0],
        [DateTime.now().add(Duration(days: 2)), -1.2],
        [DateTime.now().add(Duration(days: 3)), 20.0],
        [DateTime.now().add(Duration(days: 4)), 2000.0],
    ];
}
