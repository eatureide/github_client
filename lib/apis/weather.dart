import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/index.dart';
import '../models/weather.dart';

Dio dio = Dio();
const String apiKey = '3474b8632e2d450abe73bcff2a5bb6c7'; // 和风天气key

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

Future<WeatherData> getWeather(String locationId, String cityName) async {
  String url = 'https://devapi.qweather.com/v7/weather/now';
  final data = await dio.get(
    url,
    queryParameters: {"location": locationId, "key": apiKey},
  );
  final dataJSON = jsonDecode(data.toString());
  final now = dataJSON['now'];
  console(now);
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
