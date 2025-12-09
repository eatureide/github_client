import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:github_clint_app/theme.dart';
import '../../models/weather.dart';

class DetailComponent extends StatelessWidget {
  final WeatherData? weatherData;
  const DetailComponent({super.key, required this.weatherData});

  buildDetailCard({
    required IconData icon,
    required String title,
    String value = '',
  }) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(child: Icon(icon)),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
                Text(value, style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildDetailCard(
                  icon: CupertinoIcons.wind,
                  title: 'Wind Speed',
                  value: (() {
                    if (weatherData == null) return '';
                    return '${weatherData!.windSpeed} km/h';
                  })(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: buildDetailCard(
                  icon: CupertinoIcons.cloud_rain,
                  title: 'Precipitation',
                  value: (() {
                    if (weatherData == null) return '';
                    return '${weatherData!.precip} mm/h';
                  })(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: buildDetailCard(
                  icon: CupertinoIcons.text_justifyleft,
                  title: 'Pressure',
                  value: (() {
                    if (weatherData == null) return '';
                    return '${weatherData!.pressure} hpa';
                  })(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: buildDetailCard(
                  icon: CupertinoIcons.drop,
                  title: 'Humidity',
                  value: (() {
                    if (weatherData == null) return '';
                    return '${weatherData!.humidity} %';
                  })(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
