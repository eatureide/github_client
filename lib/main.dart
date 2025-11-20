import 'package:flutter/material.dart';
import 'provider/weather_provider.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 145, 185, 239),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home: ChangeNotifierProvider(
        create: (context) => WeatherModel(),
        child: Homescreen(),
      ),
    );
  }
}
