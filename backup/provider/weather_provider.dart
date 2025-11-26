import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import '../helper/index.dart';
import 'model.dart';
import './weather.dart';
// import 'dart:convert';

class WeatherModel extends ChangeNotifier {
  Dio dio = Dio();
  late Weather weather;
  String mapKey = '74ce91a9fbf8c89fa66b1d0f8427b417';
  String weatherKey = '9a561f25578d9c646c28d29df7eabd94';
  late List<GeocodeItem> cityList = [];

  updateCityList(List<GeocodeItem> list) {
    cityList = [...list];
    notifyListeners();
  }

  // 根据城市获取经纬度
  locationToLatLng(String city) {
    String url = 'https://restapi.amap.com/v3/geocode/geo';
    dynamic queryParameters = {"key": mapKey, "address": city, "city": city};
    return dio.get(url, queryParameters: queryParameters);
  }

  // 根据经纬度获取天气
  getWeatherData(GeocodeItem item) async {
    final response = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        "lat": item.latitude,
        "lon": item.longitude,
        "units": 'metric',
        "appid": weatherKey,
      },
    );
    final extractedData = response.data as Map<String, dynamic>;
    return Weather.fromJson(extractedData);
  }

  getDailyWeather(GeocodeItem item) async {
    String dailyUrl =
        'https://api.openweathermap.org/data/2.5/onecall?lat=${item.latitude}&lon=${item.longitude}&units=metric&exclude=minutely,current&appid=$weatherKey';
    print(dailyUrl);

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/onecall',
      queryParameters: {
        "lat": item.latitude,
        "lon": item.longitude,
        "units": 'metric',
        "exclude": "minutely,current",
        "appid": weatherKey,
      },
    );

    final extractedData = response.data as Map<String, dynamic>;
    return Weather.fromJson(extractedData);
  }
}
