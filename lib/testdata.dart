import 'infoio.dart';
import 'dart:math';

final rng = new Random();

DateTime _toSimple(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day);
}

void populateWithTestData() async {
  _getMonthlyInfo().forEach((e) => addStatic(e['money'], e['dt']));
  _getYearlyInfo().forEach((e) => addStatic(e['money'], e['dt']));
  _getAllTimeInfo().forEach((e) => addStatic(e['money'], e['dt']));
}

DateTime _toMonth(DateTime dt) => DateTime(dt.year, dt.month);
DateTime _toYear(DateTime dt) => DateTime(dt.year);

List<Map<String, dynamic>> _getMonthlyInfo() {
  return List.generate(DateTime.now().day, (i) {
    return{
      'dt': _toSimple(DateTime.now().subtract(Duration(days: i))),
      'money': (rng.nextDouble() - 0.5) * 100
    };
  });
}

List<Map<String, dynamic>> _getYearlyInfo() {
  return List.generate(DateTime.now().month, (i) {
    return {
      'dt': _toMonth(DateTime.now().subtract(Duration(days: 31*(i+1)))),
      'money': (rng.nextDouble() - 0.5) * 100
    };
  });
}

List<Map<String, dynamic>> _getAllTimeInfo() {
  return List.generate(15, (i) => {
    'dt': _toYear(DateTime.now().subtract(Duration(days: 365*i))),
    'money': (rng.nextDouble() - 0.5) * 100
  });
}
