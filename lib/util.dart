DateTime _toSimple(DateTime dt) => new DateTime(dt.year, dt.month, dt.day);
DateTime today() => _toSimple(DateTime.now());
