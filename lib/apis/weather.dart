import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/index.dart';
import '../models/weather.dart';

Dio dio = Dio();
const String apiKey = '3474b8632e2d450abe73bcff2a5bb6c7'; // 和风天气key

Future<List<HourItem>> getHourWeather(String locationId) async {
  String url = 'https://devapi.qweather.com/v7/weather/24h';
  Response<dynamic> response = await dio.get(
    url,
    queryParameters: {"location": locationId, "key": apiKey},
  );
  final Map<String, dynamic> parseResponse = response.data;
  if (parseResponse['code'] != '200') {
    throw Exception('Failed to load city ID');
  }
  List<dynamic> hourly = parseResponse['hourly'];

  List<HourItem> listHour = hourly.map((item) {
    String fxTime = item['fxTime'];

    // 步骤 1: 找到偏移量开始的位置
    int offsetIndex = fxTime.lastIndexOf('+');
    // 步骤 2: 截取不包含偏移量的部分 (如果找不到 + 号，则截取整个字符串)
    fxTime = (offsetIndex != -1) ? fxTime.substring(0, offsetIndex) : fxTime;
    int hour = DateTime.parse(fxTime).hour;

    return HourItem(
      hour: hour,
      pop: item['pop'],
      fxTime: item['fxTime'],
      icon: item['icon'],
      temp: item['temp'],
    );
  }).toList();

  return listHour;
}

Future<Map<String, dynamic>> getCityId(String city) async {
  String url = 'https://geoapi.qweather.com/v2/city/lookup';
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

Future<List<DayItem>> get7DaysWeather(String locationId) async {
  String url = 'https://devapi.qweather.com/v7/weather/7d';
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
      textDay:item['textDay'],
      tempMaxInt: int.tryParse(tempMax) ?? 0,
      tempMax: tempMax,
    );
  }).toList();

  return listDay;
}

Future<WeatherData> getWeather(String locationId, String cityName) async {
  String url = 'https://devapi.qweather.com/v7/weather/now';
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

Future<String> getCityName({required String locationStr}) async {
  String url = 'https://geoapi.qweather.com/v2/city/lookup';
  final data = await dio.get(
    url,
    queryParameters: {"location": locationStr, "key": apiKey},
  );
  final dataJSON = jsonDecode(data.toString());
  return dataJSON['location'][0]['name'];
}
