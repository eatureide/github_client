import '../helper/index.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class WeatherModel extends ChangeNotifier {
  String apiKey = '9a561f25578d9c646c28d29df7eabd94';
  int _count = 0;
  Dio dio = Dio();

  int get count => _count;
  void increment() {
    _count++;
    notifyListeners();
  }

  getWeatherData(BuildContext context) async {
    String latitude = '40.6892';
    String longitude = '-74.0445';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';
    Response response = await dio.get(url);
    console(response);
  }
}
