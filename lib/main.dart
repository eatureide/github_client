import 'package:flutter/material.dart';
import 'package:github_clint_app/routers/home_screen.dart';
import 'package:github_clint_app/routers/weather_screen/index.dart';
import 'theme.dart';
import 'routers/sticky_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ProductSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'ProductSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light, // 跟随系统
      initialRoute: '/weather',
      routes: {
        // '/': (context) => HomeScreen(),
        '/weather': (context) => WeatherScreen(),
        // '/sticky': (context) => SimpleWeatherChart(),
      },
    );
  }
}
