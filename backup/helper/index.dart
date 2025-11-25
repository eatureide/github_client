import 'dart:developer';
import 'dart:convert';
import '../provider/model.dart';

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

getTime() {
  DateTime now = DateTime.now();
  const List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  int year = now.year;
  int month = now.month;
  int day = now.day;
  int hour = now.hour;
  int minute = now.minute;
  int second = now.second;
  int millisecond = now.millisecond;
  String weekday = weekdays[now.weekday];
  String miniMonth = months[month - 1];

  return Time(
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
    millisecond: millisecond,
    weekday: weekday,
    miniMonth: miniMonth,
  );
}

String getWeatherImage(String input) {
  String weather = input.toLowerCase();
  String assetPath = 'assets/images/';
  switch (weather) {
    case 'thunderstorm':
      // return assetPath + 'Storm.png';
      return '${assetPath}Storm.png';

    case 'drizzle':
    case 'rain':
      return assetPath + 'Rainy.png';

    case 'snow':
      return assetPath + 'Snow.png';

    case 'clear':
      return assetPath + 'Sunny.png';

    case 'clouds':
      return assetPath + 'Cloudy.png';

    case 'mist':
    case 'fog':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'sand':
    case 'ash':
      return assetPath + 'Fog.png';

    case 'squall':
    case 'tornado':
      return assetPath + 'StormWindy.png';

    default:
      return assetPath + 'Cloud.png';
  }
}


String uviValueToString(double uvi) {
  if (uvi <= 2) {
    return 'Low';
  } else if (uvi <= 5) {
    return 'Medium';
  } else if (uvi <= 7) {
    return 'High';
  } else if (uvi <= 10) {
    return 'Very High';
  } else if (uvi >= 11) {
    return 'Extreme';
  }
  return 'Unknown';
}