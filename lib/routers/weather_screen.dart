import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreen();
}

class _WeatherScreen extends State<WeatherScreen> {
  TextEditingController cityController = TextEditingController();
  ScrollController scrollviewController = ScrollController();
  double statusBarHeight = 0;
  int pageNavBarIndex = 0;
  double currentPosition = 0;

  // 温度初始top
  double originalBigTempTop = 0;
  // 温度当前top（计算上状态栏）
  double bigTempTop = 150;

  Color bigTempColor = Colors.white;
  double bigTempFontSize = 112;
  double originBigTempFontSize = 112;
  double headerBackgroundOpacity = 1;
  double feelsLikeFontSize = 18;

  @override
  initState() {
    super.initState();
    scrollviewController.addListener(pageScroll);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      statusBarHeight = MediaQuery.of(context).padding.top;
      bigTempTop = bigTempTop + statusBarHeight;
      originalBigTempTop = bigTempTop;
    });
  }

  // 根据页面位置控制头部动画细节
  pageScroll() {
    controlTemp();
    controlBackground();
  }

  // 控制背景透明度
  controlBackground() {
    double bgMaxPosition = 170;
    double bgSlidePersent = currentPosition / bgMaxPosition;

    // 控制背景图透明度
    if (bgSlidePersent <= 1) {
      headerBackgroundOpacity = 1 - bgSlidePersent;
    }
  }

  // 控制温度的位置
  controlTemp() {
    final double maxPosition = 230.0;
    // 获取当前的滚动偏移量
    final double scrollOffset = scrollviewController.offset;

    // 1. 计算元素相对于初始位置的位移：
    // 如果滚动条向下滚动了 50 像素，元素的位移就是 50 像素。
    // 如果滚动条向上滚动了 50 像素（scrollOffset为负值，但在滚动视图中一般是正值，越向下越大），元素的位移应减少。

    // 2. 计算元素的目标位置
    double newPosition = originalBigTempTop + scrollOffset;

    // 3. 限制新位置在 [150,230] 的范围内：
    // 如果滚动条向下滑，元素的位置不应超过230
    if (newPosition > maxPosition) {
      newPosition = maxPosition;
    }

    // 4. 更新状态
    // 只有在新位置与旧位置不同时才调用 setState，以避免不必要的重绘。
    if (bigTempTop != newPosition) {
      setState(() {
        bigTempTop = newPosition;
      });
    }
  }

  // 顶部时间和天气组件
  headerComponent() {
    // 背景图
    backgroundComponent() {
      return Positioned.fill(
        top: 0,
        left: 0,
        child: Container(
          color: headerColor,
          child: AnimatedOpacity(
            opacity: headerBackgroundOpacity,
            duration: Duration(microseconds: 100),
            child: Image(
              image: AssetImage('assets/images/header.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // 输入框
    inputComponent() {
      return Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Row(
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
        ),
      );
    }

    // 当前温度
    currentTempComponent() {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        left: 14,
        top: bigTempTop,
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Container(
                color: Colors.transparent,
                child: AnimatedDefaultTextStyle(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 100),
                  style: TextStyle(
                    color: bigTempColor,
                    fontSize: bigTempFontSize,
                  ),
                  child: Text('3°'),
                ),
              ),
              AnimatedDefaultTextStyle(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 100),
                style: TextStyle(
                  color: bigTempColor,
                  fontSize: feelsLikeFontSize,
                ),
                child: Transform.translate(
                  offset: Offset(-10.0, 0.0),
                  child: Text('Feels Like 5°'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 当前天气状况
    currentWeatherComponent() {
      return Positioned(
        top: 10,
        right: 24,
        child: Column(
          children: [
            Icon(Icons.wb_sunny_rounded, size: 100, color: Colors.white),
            Text('Cloudy', style: TextStyle(fontSize: 22, color: Colors.white)),
          ],
        ),
      );
    }

    // 当前时间
    currentTimeComponent() {
      // 日期时间
      return Positioned(
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
      );
    }

    // 当天最高最低温度
    currentHighLowTempComponent() {
      return Positioned(
        bottom: 18,
        right: 24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Day 3°', style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(
              'Night 1°',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 412,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          backgroundComponent(),
          // inputComponent(),
          currentTempComponent(),
          // currentWeatherComponent(),
          // currentTimeComponent(),
          // currentHighLowTempComponent(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: pageNavBarComponent(),
          ),
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
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollviewController,
        child: Column(
          children: [
            headerComponent(),
            SizedBox(height: 16),
            pageNavBarComponent(),
            SizedBox(height: 16),
            detailComponent(),
            SizedBox(height: 1000),
          ],
        ),
      ),
    );
  }
}
