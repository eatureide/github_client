import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreen();
}

class _WeatherScreen extends State<WeatherScreen> {
  TextEditingController cityController = TextEditingController();
  int pageNavBarIndex = 0;

  // 顶部时间和天气组件
  headerComponent() {
    inputComponent() {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: cityController,
              style: TextStyle(color: Colors.white, fontSize: 22),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search City',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(160, 255, 255, 255),
                ),
                filled: true,
                fillColor: Colors.transparent,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      );
    }

    detailComponent() {
      return Expanded(
        child: Stack(
          children: [
            // 当前温度
            Positioned(
              left: 24,
              top: 60,
              child: Column(
                children: [
                  Text(
                    '3°',
                    style: TextStyle(
                      height: 0.8,
                      color: Colors.white,
                      fontSize: 112,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Feels Like 5°',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            // 当前天气状况
            Positioned(
              top: 10,
              right: 24,
              child: Column(
                children: [
                  Icon(Icons.wb_sunny_rounded, size: 100, color: Colors.white),
                  Text(
                    'Cloudy',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ],
              ),
            ),
            // 日期时间
            Positioned(
              bottom: 18,
              left: 24,
              child: Column(
                children: [
                  Text(
                    'January 18, 16:14',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            // 当天最高最低温度
            Positioned(
              bottom: 18,
              right: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Day 3°',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Night 1°',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 412,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/header.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          inputComponent(),
          detailComponent(),
        ],
      ),
    );
  }

  pageNavBarComponent() {
    List<dynamic> buttoms = [
      {'title': 'Today', 'index': 0},
      {'title': 'Tomorrow', 'index': 1},
      {'title': '10days', 'index': 2},
    ];
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttoms.map((item) {
          Color backgroundColor = pageNavBarIndex == item['index']
              ? Color.fromARGB(255, 222, 183, 252)
              : Colors.white;
          return Container(
            width: 120,
            color: Colors.transparent,
            child: TextButton(
              onPressed: () {
                setState(() {
                  pageNavBarIndex = item['index'];
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                item['title'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  detailComponent() {
    buildDetailCard({required IconData icon, required String title}) {
      return Container(
        width: 186,
        height: 76,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 222, 253),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(child: Icon(icon)),
              ),
              SizedBox(width: 12),
              Column(children: [Text(title)]),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildDetailCard(icon: CupertinoIcons.wind, title: 'Wind Speed'),
              buildDetailCard(
                icon: CupertinoIcons.cloud_rain,
                title: 'Rain chance',
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildDetailCard(
                icon: CupertinoIcons.text_justifyleft,
                title: 'Pressure',
              ),
              buildDetailCard(icon: CupertinoIcons.sun_min, title: 'UV Index'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            headerComponent(),
            SizedBox(height: 16),
            pageNavBarComponent(),
            SizedBox(height: 16),
            detailComponent(),
          ],
        ),
      ),
    );
  }
}
