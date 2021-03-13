Future<Map<DateTime, double>> getInfo([int limit = 25]) async {
    return {
        DateTime.now(): 10.5,
        DateTime.now(): 0.0,
        DateTime.now(): -1.2,
        DateTime.now(): 20.0,
        DateTime.now(): 2000.0,
    };
}
