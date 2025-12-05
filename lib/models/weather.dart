class WeatherData {
  final String? temp;
  final String text;
  final String humidity;
  final String windDir;
  final String windScale;
  final String pressure;
  final String cityName;
  final String feelsLike;
  final String windSpeed;
  final String obsTime;
  final String icon;
  final String precip;

  WeatherData({
    required this.precip,
    required this.temp,
    required this.text,
    required this.humidity,
    required this.windDir,
    required this.windScale,
    required this.pressure,
    required this.cityName,
    required this.feelsLike,
    required this.windSpeed,
    required this.obsTime,
    required this.icon,
  });
}

class HourItem {
  final String fxTime;
  final String temp;
  final String icon;
  final int hour;
  final String pop;

  HourItem({
    required this.fxTime,
    required this.temp,
    required this.icon,
    required this.hour,
    required this.pop
  });
}

class DayItem {
  final String tempMax;
  final int tempMaxInt;
  final String fxDate;
  final String sunrise;
  final String sunset;

  DayItem({
    required this.sunrise,
    required this.sunset,
    required this.tempMax,
    required this.fxDate,
    required this.tempMaxInt,
  });
}
