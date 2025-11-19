import '../helper/index.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'model.dart';

class WeatherModel extends ChangeNotifier {
  Dio dio = Dio();
  String mapKey = '74ce91a9fbf8c89fa66b1d0f8427b417';
  String weatherKey = '9a561f25578d9c646c28d29df7eabd94';
  late List<GeocodeItem> cityList = [];

  updateCityList(List<GeocodeItem> list) {
    cityList = [...list];
    notifyListeners();
  }

  // 根据城市获取经纬度
  // http://api.openweathermap.org/geo/1.0/direct?q=guangzhou&limit=5&appid=9a561f25578d9c646c28d29df7eabd94
  locationToLatLng(String city) {
    // https://restapi.amap.com/v3/geocode/geo?key=74ce91a9fbf8c89fa66b1d0f8427b417&address=guangzhou
    String url = 'https://restapi.amap.com/v3/geocode/geo';
    dynamic queryParameters = {"key": mapKey, "address": city, "city": city};
    return dio.get(url, queryParameters: queryParameters);
  }

  getWeatherData(BuildContext context) async {
    String latitude = '40.6892';
    String longitude = '-74.0445';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$weatherKey';
    Response response = await dio.get(url);
    console(response);
  }
}
