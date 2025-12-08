import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/index.dart';
import '../models/weather.dart';
import 'package:intl/intl.dart';

Dio dio = Dio();
String apiKey = '3474b8632e2d450abe73bcff2a5bb6c7'; // 和风天气key
String apiHost = 'https://k8359588yt.re.qweatherapi.com'; // 和风天气host

// 根据城市id获取当前城市24小时的天气状况
Future<List<HourItem>> getHourWeather(String locationId) async {
  String url = '$apiHost/v7/weather/24h';
  Response<dynamic> response = await dio.get(
    url,
    queryParameters: {"location": locationId, "key": apiKey},
  );
  final Map<String, dynamic> parseResponse = response.data;
  if (parseResponse['code'] != '200') {
    throw Exception('Failed to load city ID');
  }
  List<dynamic> hourly = parseResponse['hourly'];

  // 得到小时
  List<HourItem> listHour = hourly.map((item) {
    String fxTime = item['fxTime'];
    int offsetIndex = fxTime.lastIndexOf('+');
    fxTime = (offsetIndex != -1) ? fxTime.substring(0, offsetIndex) : fxTime;
    int hour = DateTime.parse(fxTime).hour;

    String time12Hour = DateFormat('h').format(DateTime.parse(fxTime));

    String hourStr = (() {
      if (hour <= 9) return '0$hour';
      return hour.toString();
    })();

    return HourItem(
      time12Hour: time12Hour,
      hourStr: hourStr,
      hour: hour,
      pop: item['pop'],
      fxTime: item['fxTime'],
      icon: item['icon'],
      temp: item['temp'],
    );
  }).toList();

  return listHour;
}

// 根据城市中文名获取城市id
Future<Map<String, dynamic>> getCityId(String city) async {
  String url = '$apiHost/geo/v2/city/lookup';
  Response<dynamic> response = await dio.get(
    url,
    queryParameters: {"location": city, "key": apiKey},
  );
  Map<String, dynamic> parseResponse = jsonDecode(response.toString());
  if (parseResponse['code'] != '200') {
    throw Exception('Failed to load city ID');
  }
  return parseResponse;
}

// 获取包含今日七天的天气数据
Future<List<DayItem>> get7DaysWeather(String locationId) async {
  String url = '$apiHost/v7/weather/7d';
  final response = await dio.get(
    url,
    queryParameters: {"location": locationId, "key": apiKey},
  );
  final Map<String, dynamic> parseResponse = response.data;
  if (parseResponse['code'] != '200') {
    throw Exception('Failed to load city ID');
  }
  List<dynamic> daily = parseResponse['daily'];
  List<DayItem> listDay = daily.map((item) {
    String tempMax = item['tempMax'];
    return DayItem(
      tempMin: item['tempMin'],
      sunrise: item['sunrise'],
      sunset: item['sunset'],
      fxDate: item['fxDate'],
      iconDay: item['iconDay'],
      textDay: item['textDay'],
      tempMaxInt: int.tryParse(tempMax) ?? 0,
      tempMax: tempMax,
    );
  }).toList();

  return listDay;
}

// 获取当日天气状况
Future<WeatherData> getWeather(String locationId, String cityName) async {
  String url = '$apiHost/v7/weather/now';
  final data = await dio.get(
    url,
    queryParameters: {"location": locationId, "key": apiKey},
  );
  final dataJSON = jsonDecode(data.toString());
  final now = dataJSON['now'];
  // console(locationId);
  return WeatherData(
    temp: now['temp'],
    text: now['text'],
    precip: now['precip'],
    humidity: now['humidity'],
    windDir: now['windDir'],
    windScale: now['windScale'],
    pressure: now['pressure'],
    feelsLike: now['feelsLike'],
    windSpeed: now['windSpeed'],
    obsTime: now['obsTime'],
    icon: now['icon'],
    cityName: cityName,
  );
}

// 获取城市名称
Future<String> getCityName({required String locationStr}) async {
  String url = '$apiHost/geo/v2/city/lookup';
  final data = await dio.get(
    url,
    queryParameters: {"location": locationStr, "key": apiKey},
  );
  final dataJSON = jsonDecode(data.toString());
  return dataJSON['location'][0]['name'];
}
