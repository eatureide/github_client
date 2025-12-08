import 'dart:developer';
import 'dart:convert';
import 'package:intl/intl.dart';

Map<String, String> weatherList = {
  '阴': 'Cloudy',
  '晴': 'Sunny',
  '多云': 'Cloudy',
  '小雨': 'Rain',
};

const Map<int, String> monthAbbreviationMap = {
  1: 'Jan', // January
  2: 'Feb', // February
  3: 'Mar', // March
  4: 'Apr', // April
  5: 'May', // May
  6: 'Jun', // June
  7: 'Jul', // July
  8: 'Aug', // August
  9: 'Sep', // September
  10: 'Oct', // October
  11: 'Nov', // November
  12: 'Dec', // December
};

const List<String> monthNames = [
  '', // 索引 0 (占位符)
  'January', // 索引 1
  'February', // 索引 2
  'March', // 索引 3
  'April', // 索引 4
  'May', // 索引 5
  'June', // 索引 6
  'July', // 索引 7
  'August', // 索引 8
  'September', // 索引 9
  'October', // 索引 10
  'November', // 索引 11
  'December', // 索引 12
];

void console(dynamic data) {
  try {
    if (data is Map || data is List) {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyData = encoder.convert(data);
      log(prettyData);
    } else {
      log(data.toString());
    }
  } catch (e) {
    log('Error logging response body: $e');
  }
}

DateTime combineTimeWithToday(String timeString) {
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fullDateTimeString = '$todayDate $timeString:00'; // 加上秒 :00
  return DateTime.parse(fullDateTimeString);
}

// 判断日期是否应该加0
String timeFormatAddZero(int timeInt) {
  if (timeInt <= 9) return '0${timeInt.toString()}';
  return timeInt.toString();
}
