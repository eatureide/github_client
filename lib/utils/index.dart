import 'dart:developer';
import 'dart:convert';
import 'package:intl/intl.dart';

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
