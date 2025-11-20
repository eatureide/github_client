import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../provider/weather_provider.dart';
import '../helper/index.dart';
import '../helper/extensions.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../provider/model.dart';
import '../provider/weather.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  Dio dio = Dio();
  final GlobalKey decorationInputKey = GlobalKey();
  List<dynamic> inputHistory = [];
  List<GeocodeItem> cityList = [];
  String currentInput = '';
  Weather? weather;
  bool weatherReady = false;
  bool isCelsius = false;

  @override
  void initState() {
    super.initState();
    initInputHistory();
  }

  initInputHistory() async {
    try {
      File file = await getLocalFile();
      String historyStr = await file.readAsString();
      if (historyStr.isEmpty) return;
      final List<dynamic> parsedList = jsonDecode(historyStr);

      setState(() {
        inputHistory = parsedList;
      });
    } on FileSystemException {
      return 0;
    }
  }

  Future<File> getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/inputHistory.txt');
  }

  handleReqLocation(GeocodeItem item) async {
    WeatherModel provider = Provider.of<WeatherModel>(context, listen: false);

    weather = await provider.getWeatherData(item);
    setState(() {
      weather = weather;
    });
  }

  handleSubmit(String value) async {
    inputHistory.add(value);
    getLocalFile().then((e) {
      e.writeAsString(jsonEncode(inputHistory));
    });
  }

  searchDialog() {
    WeatherModel provider = Provider.of<WeatherModel>(context, listen: false);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double statusBarHeight = mediaQuery.padding.top;
    late double top = 0;

    final RenderBox? renderBox =
        decorationInputKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset position = renderBox.localToGlobal(Offset.zero);
      top = position.dy;
    }

    Color mainColor = Theme.of(context).primaryColor;
    EdgeInsets padding = EdgeInsets.fromLTRB(16, 0, 16, 0);

    renderListView() {
      return ListView(
        scrollDirection: Axis.vertical,
        children: cityList.map((item) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              handleReqLocation(item);
            },
            child: Container(
              height: 50,
              padding: padding,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color.fromARGB(32, 0, 0, 0),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.formattedAddress, style: TextStyle(fontSize: 16)),
                  Icon(CupertinoIcons.location_solid, color: Colors.black),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    listComponent() {
      return Container(
        margin: EdgeInsets.only(top: 16),
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(child: renderListView()),
        ),
      );
    }

    handleInput(String value, StateSetter dialogSetState) async {
      Response res = await provider.locationToLatLng(value);
      if (res.data == null ||
          res.data.isEmpty ||
          res.data['infocode'] != '10000') {
        return;
      }

      List<GeocodeItem> geocodeItems = (res.data['geocodes'] as List).map((
        item,
      ) {
        List<String> arr = (item['location'] as String).split(',');
        return GeocodeItem(
          formattedAddress: item['formatted_address'] as String,
          latitude: double.tryParse(arr[1].trim()) ?? 0.0,
          longitude: double.tryParse(arr[0].trim()) ?? 0.0,
        );
      }).toList();

      dialogSetState(() {
        currentInput = value;
        cityList = geocodeItems;
      });
    }

    inputComponent(StateSetter dialogSetState) {
      return Container(
        padding: padding,
        margin: EdgeInsets.only(top: top - statusBarHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Material(
                child: TextField(
                  onChanged: (e) {
                    handleInput(e, dialogSetState);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
            Icon(CupertinoIcons.multiply, color: mainColor),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: padding,
                color: Colors.transparent,
                child: Column(
                  children: [inputComponent(dialogSetState), listComponent()],
                ),
              ),
            );
          },
        );
      },
    );
  }

  searchInput() {
    Color mainColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        searchDialog();
      },
      child: Container(
        key: decorationInputKey,
        height: 50,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(52, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentInput.isEmpty ? 'Search...' : currentInput,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Icon(CupertinoIcons.search, color: mainColor),
          ],
        ),
      ),
    );
  }

  showSwitch(bool action) {
    setState(() {
      isCelsius = action;
    });
  }

  location() {
    Time time = getTime();
    Color mainColor = Theme.of(context).primaryColor;
    if (weather == null) {
      return Container();
    }
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weather!.city,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${time.weekday} ${time.miniMonth}, ${time.day} ${time.year}  ${time.hour}:${time.minute} ${time.hour <= 12 ? 'AM' : 'PM'}',
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 238, 238, 238),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 100,
            height: 40,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  top: 4,
                  left: isCelsius ? 4 : 52,
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 45,
                    height: 32,
                  ),
                ),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showSwitch(true);
                      },
                      child: Container(
                        width: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            '℃',
                            style: TextStyle(
                              color: isCelsius ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSwitch(false);
                      },
                      child: Container(
                        width: 50,
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            '℉',
                            style: TextStyle(
                              color: isCelsius ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  renderTemp() {
    if (weather == null) return Container();
    String temp = isCelsius
        ? weather!.temp.toStringAsFixed(1)
        : weather!.temp.toFahrenheit().toStringAsFixed(1);

    tempComponent() {
      return Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  temp,
                  style: TextStyle(
                    height: 1,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(weather!.description),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
              color: Colors.transparent,
              child: Text(
                isCelsius ? '℃' : '℉',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    renderWeatherImage() {
      return SizedBox(
        height: 100.0,
        width: 100.0,
        child: Image.asset(
          getWeatherImage(weather!.weatherCategory),
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [tempComponent(), renderWeatherImage()],
      ),
    );
  }

  todayDetail() {
    if (weather == null) return Container();
    Color mainColor = Theme.of(context).primaryColor;
    itemComponent(
      String title, [
      String subTitle = 'subTitle',
      PhosphorFlatIconData icon = PhosphorIconsRegular.thermometerSimple,
    ]) {
      return Container(
        width: 120,
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(60),
              ),
              child: PhosphorIcon(icon, color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12)),
                Text(subTitle, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      height: 160,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 243, 248, 254),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemComponent(
                'Feels Like',
                isCelsius
                    ? '${weather!.feelsLike.toStringAsFixed(1)}°'
                    : '${weather!.feelsLike.toFahrenheit().toStringAsFixed(1)}°',
                PhosphorIconsRegular.thermometerSimple,
              ),
              itemComponent('Rain', 'Error', PhosphorIconsRegular.drop),
              itemComponent('UV Index', 'Error', PhosphorIconsRegular.sun),
            ],
          ),
          Container(height: 1, color: mainColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemComponent(
                'Wind',
                '${weather!.windSpeed} m/s',
                PhosphorIconsRegular.wind,
              ),
              itemComponent(
                'Humidity',
                '${weather!.humidity}%',
                PhosphorIconsRegular.dropHalfBottom,
              ),
              itemComponent('Cloudiness', 'Error', PhosphorIconsRegular.cloud),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Weather')),
      body: SingleChildScrollView(
        child: Consumer<WeatherModel>(
          builder: (context, provider, child) {
            return Container(
              color: Colors.transparent,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchInput(),
                  location(),
                  renderTemp(),
                  todayDetail(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
