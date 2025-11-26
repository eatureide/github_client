import 'package:flutter/material.dart';
import 'package:github_clint_app/utils/index.dart';
import '../apis/weather.dart';
import '../models/weather.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController cityController = TextEditingController();
  bool isLoading = false;
  WeatherData? weatherData;

  @override
  initState() {
    super.initState();
    locateAndFetch();
  }

  locateAndFetch() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('定位服务未开启');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        console(permission);
        if (permission == LocationPermission.denied) {
          throw Exception('定位权限被拒绝');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('定位权限被永久拒绝，请去设置中开启');
      }

      LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.low,
        forceLocationManager: true,
        timeLimit: Duration(seconds: 5),
      );

      // 3. 获取位置 (High 精度)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // 使用新的设置
      );
      String locationStr =
          "${position.longitude.toStringAsFixed(2)},${position.latitude.toStringAsFixed(2)}";
      fetchWeatherLogic(locationStr: locationStr);
    } catch (e) {
      console('定位失败: $e');
    }
  }

  fetchWeatherLogic({required String locationStr}) async {
    String cityName = await getCityName(locationStr: locationStr);
    fetchWeather(cityName);
  }

  // 根据城市获取天气信息
  fetchWeather(String cityName) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> cityIdData = await getCityId(cityName);
    String cityId = cityIdData['location'][0]['id'];
    WeatherData now = await getWeather(cityId, cityName);

    setState(() {
      weatherData = now;
      isLoading = false;
    });
  }

  buildSearchBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: cityController,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: '搜索城市 (如: 杭州)',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest, // 浅灰/深灰背景
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              fetchWeather(cityController.text);
            },
          ),
        ),
        onSubmitted: (value) {
          fetchWeather(cityController.text);
        },
      ),
    );
  }

  // 根据天气描述返回对应图标
  IconData getWeatherIcon(String text) {
    if (text.contains('晴')) return Icons.wb_sunny_rounded;
    if (text.contains('云') || text.contains('阴')) return Icons.cloud_rounded;
    if (text.contains('雨')) return Icons.water_drop_rounded;
    if (text.contains('雪')) return Icons.ac_unit_rounded;
    if (text.contains('雷')) return Icons.thunderstorm_rounded;
    if (text.contains('雾') || text.contains('霾')) return Icons.foggy;
    return Icons.wb_cloudy_rounded; // 默认
  }

  buildDetailCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colorScheme.primary),
            Spacer(),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    buildLoading() {
      if (!isLoading) return Container();
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: LinearProgressIndicator(borderRadius: BorderRadius.circular(10)),
      );
    }

    buildWeatherData() {
      if (weatherData == null || isLoading) return Container();
      return Expanded(
        child: ListView(
          children: [
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    Text(
                      weatherData!.cityName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Icon(
                      getWeatherIcon(weatherData!.text),
                      size: 60,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    Text(
                      '${weatherData!.temp}°',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(weatherData!.text, style: theme.textTheme.titleLarge),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "详细数据",
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true, // 允许 GridView 在 ListView 中
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // 两列
              childAspectRatio: 1.5, // 卡片宽高比
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                buildDetailCard(
                  context,
                  Icons.water_drop_outlined,
                  "相对湿度",
                  "${weatherData!.humidity}%",
                ),
                buildDetailCard(
                  context,
                  Icons.air,
                  "风向风力",
                  "${weatherData!.windDir} ${weatherData!.windScale}级",
                ),
                buildDetailCard(
                  context,
                  Icons.speed,
                  "大气压强",
                  "${weatherData!.pressure} hPa",
                ),
                buildDetailCard(
                  context,
                  Icons.thermostat,
                  "体感温度",
                  // 这里简单复用温度，实际 API 有 feelsLike
                  "${weatherData!.temp}°",
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface, // M3 标准背景色
      appBar: AppBar(
        title: Text('天气助手'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0, // 滚动时不改变颜色
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            buildLoading(),
            SizedBox(height: 10),
            buildSearchBar(),
            SizedBox(height: 10),
            buildWeatherData(),
          ],
        ),
      ),
    );
  }
}
