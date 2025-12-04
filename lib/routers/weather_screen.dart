import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import '../component/curve.dart';
import '../component/rain.dart';
import '../component/sun.dart';
import '../component/hourly.dart';
import '../component/days.dart';
import '../apis/weather.dart';
import '../utils/index.dart';
import '../models/weather.dart';

const List<String> monthNames = [
  '', // 索引 0 (占位符)
  'January', // 索引 1
  'February', // 索引 2
  'March', // 索引 3
  'April', // 索引 4
  'May', // 索引 5
  'June', // 索引 6
  'July', // 索引 7
  'August', // 索引 8
  'September', // 索引 9
  'October', // 索引 10
  'November', // 索引 11
  'December', // 索引 12
];

// 继承自 SliverPersistentHeaderDelegate 的类，用于实现 Header 的布局和变化逻辑
class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  // 核心方法: 构建 Header 的实际内容
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  // 是否需要重新构建 Header。通常保持为 true 或在需要时进行更复杂的判断。
  @override
  bool shouldRebuild(StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

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
  WeatherData? weatherData;
  String updateTime = '';

  // 当前滚动位置
  double currentOffset = 0;

  // 头部字体颜色
  Color curTempColor = Colors.white;
  Color curTempColorBlack = Colors.black;
  Color curTempColorWhite = Colors.white;

  // 背景图当前透明度
  double headerBackgroundOpacity = 1.0;

  // 当前温度初始top
  double curTempBottomOriginal = 106.0;
  // 当前温度bottom
  double curTempBottom = 106.0;
  // 当前温度bottom最大限制
  double curTempBottomMax = 65.0;
  // 当前温度当前字体
  double curTempMaxFontSize = 112.0;
  // 当前温度最大字体
  double curTempFontSizeMax = 112.0;
  // 当前温度最小字体
  double curTempFontSizeMin = 57.0;

  // 体感温度当前字体
  double feelsLikeFontSize = 18.0;
  // 体感温度最大
  double feelsLikeFontSizeMax = 18.0;
  // 体感温度最小
  double feelsLikeFontSizeMin = 14.0;

  // 底部信息bottom原始位置
  double footerBottomOriginal = 24;
  // 底部信息bottom位置
  double footerBottom = 24;
  // 底部信息bottom最大位置
  double footerBottomMax = -48;

  // 控制导航栏位置
  double footerNavBarBottomOriginal = -50;
  double footerNavBarBottom = -50;
  double footerNavBarBottomMax = 12;

  // 控制卡片圆角
  double footerRadius = 24;
  double footerRadiusMax = 24;
  double footerRadiusMin = 0;

  // 控制天气图标位置
  double weatherIconBottomOriginal = 180;
  double weatherIconBottom = 180;
  double weatherIconBottomMax = 56;

  // 控制天气图标大小
  double weatherIconSizeOriginal = 120;
  double weatherIconSize = 120;
  double weatherIconSizeMax = 70;

  // 控制天气图标文字
  double weatherIconFontOpacity = 1;

  final GlobalKey headerKey = GlobalKey();
  final GlobalKey navBarKey = GlobalKey();

  @override
  initState() {
    super.initState();
    scrollviewController.addListener(pageScroll);
    requestCityData();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQueryData = MediaQuery.of(context);
    statusBarHeight = mediaQueryData.padding.top;
  }

  requestCityData() async {
    Map<String, dynamic> response = await getCityId('广州');
    final {'location': location} = response;
    final {'id': id, 'name': name} = location[0];
    WeatherData now = await getWeather(id, name);
    DateTime date = DateTime.parse(now.obsTime);

    String month = monthNames[date.month];
    int day = date.day;
    int hour = date.hour;
    int min = date.minute;
    String dateStr = '$month $day,  $hour:$min';

    setState(() {
      updateTime = dateStr;
      weatherData = now;
    });
    // console(date.month);
  }

  // 根据页面位置控制头部动画细节
  pageScroll() {
    controlTemp();
    controlWeather();
    controlBackground();
    controFooter();
  }

  // 控制背景透明度
  controlBackground() {
    double currentPosition = scrollviewController.offset;
    double bgMaxPosition = 100;
    double bgSlidePersent = currentPosition / bgMaxPosition;

    if (bgSlidePersent > 1) {
      weatherIconFontOpacity = 1;
      bgSlidePersent = 1;
    }

    setState(() {
      headerBackgroundOpacity = 1 - bgSlidePersent;
      weatherIconFontOpacity = 1 - bgSlidePersent;
    });
  }

  // 控制天气图标位置
  controlWeather() {
    final double scrollOffset = scrollviewController.offset;
    double newPosition = weatherIconBottomOriginal - scrollOffset;
    double newSize = weatherIconSizeOriginal - scrollOffset;

    if (newPosition < weatherIconBottomMax) {
      newPosition = weatherIconBottomMax;
    }

    if (newSize < weatherIconSizeMax) {
      newSize = weatherIconSizeMax;
    }

    setState(() {
      weatherIconBottom = newPosition;
      weatherIconSize = newSize;
      weatherIconFontOpacity = weatherIconFontOpacity;
    });
  }

  // 控制底部位置
  controFooter() {
    final RenderBox renderBoxA =
        headerKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBoxB =
        navBarKey.currentContext?.findRenderObject() as RenderBox;
    final Size sizeA = renderBoxA.size;
    final Offset positionA = renderBoxA.localToGlobal(Offset.zero);
    final Rect rectA = positionA & sizeA;
    final Size sizeB = renderBoxB.size;
    final Offset positionB = renderBoxB.localToGlobal(Offset.zero);
    final Rect rectB = positionB & sizeB;
    final bool overlapping = rectA.overlaps(rectB);
    String direction = scrollviewController.offset < currentOffset
        ? 'up'
        : 'down';

    setState(() {
      currentOffset = scrollviewController.offset;
      if (overlapping && direction == 'down') {
        footerBottom = footerBottomMax;
        footerNavBarBottom = footerNavBarBottomMax;
        footerRadius = footerRadiusMin;
      }
      if (!overlapping && direction != 'down') {
        footerNavBarBottom = footerNavBarBottomOriginal;
        footerBottom = footerBottomOriginal;
        footerRadius = footerRadiusMax;
      }
    });
  }

  // 控制温度的位置
  controlTemp() {
    final double maxPosition = curTempBottomMax;
    final double scrollOffset = scrollviewController.offset;
    final double minFontSize = curTempFontSizeMin;

    double newFontSize = curTempFontSizeMax - scrollOffset;
    double newPosition = curTempBottomOriginal - scrollOffset;

    // 计算字体颜色
    Color newFontColor = curTempColorWhite;
    // 计算体感温度字体大小
    double newFeelsLikeFont = feelsLikeFontSizeMax;

    // 如果滚动超出最小限制了，则保持在最大字体值
    if (newFontSize < minFontSize) {
      newFontSize = minFontSize;
      newFontColor = curTempColorWhite;
      newFeelsLikeFont = feelsLikeFontSizeMax;
    }

    if (newPosition < maxPosition) {
      newPosition = maxPosition;
      newFontColor = curTempColorBlack;
      newFeelsLikeFont = feelsLikeFontSizeMin;
    }

    setState(() {
      curTempMaxFontSize = newFontSize;
      curTempBottom = newPosition;
      curTempColor = newFontColor;
      feelsLikeFontSize = newFeelsLikeFont;
    });
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
      return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: TextField(
            controller: cityController,
            style: TextStyle(color: curTempColor, fontSize: 22),
            cursorColor: curTempColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search City',
              hintStyle: TextStyle(color: curTempColor),
              filled: true,
              fillColor: Colors.transparent,
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: curTempColor),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
    }

    // 当前温度
    currentTempComponent() {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        left: 20,
        bottom: curTempBottom,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.bottomCenter,
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
                    color: curTempColor,
                    fontSize: curTempMaxFontSize,
                  ),
                  child: (() {
                    if (weatherData == null) return Text('-°');
                    return Text('${weatherData!.temp}°');
                  })(),
                ),
              ),
              AnimatedDefaultTextStyle(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 100),
                style: TextStyle(
                  color: curTempColor,
                  fontSize: feelsLikeFontSize,
                ),
                child: Transform.translate(
                  offset: Offset(-10.0, 0.0),
                  child: (() {
                    if (weatherData == null) return Text('0°');
                    return Text('Feels Like ${weatherData!.feelsLike}°');
                  })(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 当前天气状况
    currentWeatherComponent() {
      Map<String, IconData> iconList = {'104': CupertinoIcons.cloud_fill};
      Map<String, String> weatherList = {'阴': 'Cloudy'};

      return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        bottom: weatherIconBottom,
        right: 12,
        child: Column(
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 400),
              child: (() {
                if (weatherData == null ||
                    iconList[weatherData!.icon] == null) {
                  return Icon(
                    CupertinoIcons.rays,
                    size: weatherIconSize,
                    color: curTempColor,
                  );
                }
                return Icon(
                  iconList[weatherData!.icon],
                  size: weatherIconSize,
                  color: curTempColor,
                );
              })(),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 400),
              style: TextStyle(fontSize: 22, color: curTempColor),
              child: AnimatedOpacity(
                opacity: weatherIconFontOpacity,
                duration: Duration(milliseconds: 300),
                child: (() {
                  if (weatherData == null ||
                      weatherList[weatherData!.text] == null) {
                    return Text('');
                  }
                  return Text(weatherList[weatherData!.text] as String);
                })(),
              ),
            ),
          ],
        ),
      );
    }

    // 底部信息
    footerComponent() {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        left: 24,
        right: 24,
        bottom: footerBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: (() {
            if (weatherData == null) return [Text('')];
            return [
              Text(
                updateTime,
                style: TextStyle(color: curTempColor, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'WindScale ${weatherData!.windScale}',
                    style: TextStyle(color: curTempColor, fontSize: 18),
                  ),
                  Text(
                    'WindSpeed ${weatherData!.windSpeed}',
                    style: TextStyle(color: curTempColor, fontSize: 18),
                  ),
                ],
              ),
            ];
          })(),
        ),
      );
    }

    // 页面导航栏包裹
    pageNavBarComponentWrap() {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        left: 0,
        right: 0,
        bottom: footerNavBarBottom,
        child: pageNavBarComponent(),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      key: headerKey,
      width: double.infinity,
      height: 412,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(footerRadius),
          bottomRight: Radius.circular(footerRadius),
        ),
      ),
      child: Stack(
        children: [
          backgroundComponent(),
          inputComponent(),
          currentTempComponent(),
          footerComponent(),
          pageNavBarComponentWrap(),
          currentWeatherComponent(),
        ],
      ),
    );
  }

  // 页面导航栏
  pageNavBarComponent() {
    List<Map<String, dynamic>> buttons = [
      {'title': 'Today', 'index': 0},
      {'title': 'Tomorrow', 'index': 1},
      {'title': '10days', 'index': 2},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons.map((item) {
          bool isSelected = pageNavBarIndex == item['index'];

          Color backgroundColor = isSelected
              ? Color.fromARGB(255, 222, 183, 252) // 选中时的背景色
              : Colors.white; // 未选中时的背景色

          Color foregroundColor = isSelected
              ? Color.fromARGB(255, 45, 2, 76) // 选中时的文字颜色
              : Colors.black; // 未选中时的文字颜色

          return Container(
            width: 116,
            color: Colors.transparent,
            child: TextButton(
              onPressed: () {
                setState(() {
                  pageNavBarIndex = item['index'];
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                minimumSize: Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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

  // 天气详情卡片小组件
  detailComponent() {
    buildDetailCard({
      required IconData icon,
      required String title,
      String value = '',
    }) {
      return Container(
        // width: 186,
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

  // 温度走势图
  weatherCurveComponent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.fromLTRB(12, 12, 24, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(CupertinoIcons.calendar, size: 14),
                ),
                Text('Day forecast', style: TextStyle(fontSize: 14)),
              ],
            ),
            CurveComponent(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        controller: scrollviewController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyHeaderDelegate(
              minHeight: 228.0,
              maxHeight: 412.0,
              child: headerComponent(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  SizedBox(height: 16),
                  pageNavBarComponent(),
                  SizedBox(height: 16, key: navBarKey),
                  detailComponent(),
                  SizedBox(height: 16),
                  Hourly(),
                  SizedBox(height: 16),
                  weatherCurveComponent(),
                  SizedBox(height: 16),
                  ChanceOfRain(), // 降雨率
                  SizedBox(height: 16),
                  SunRiseAndSet(), // 日出日落时间
                  SizedBox(height: 16),
                  Days(),
                  SizedBox(height: 100),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
