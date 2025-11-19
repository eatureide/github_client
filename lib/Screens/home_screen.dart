import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../provider/weather_provider.dart';
import '../helper/index.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../provider/model.dart';

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
      // console(parsedList);
    } on FileSystemException {
      return 0;
    }
  }

  Future<File> getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/inputHistory.txt');
  }

  handleReqLocation() async {
    // WeatherModel provider = Provider.of<WeatherModel>(context, listen: false);
    // Response res = await provider.locationToLatLng(currentInput);
    // console(res.data['geocodes']);

    // List<String> location = res.data['geocodes'][0]['location'].split(',');
    // Response data = await dio.get(
    //   "https://api.openweathermap.org/data/2.5/weather",
    //   queryParameters: {
    //     "lat": location[1],
    //     "lon": location[0],
    //     "units": 'metric',
    //     "appid": provider.weatherKey,
    //   },
    // );
    // console(data);
  }

  handleSubmit(String value) async {
    inputHistory.add(value);
    getLocalFile().then((e) {
      e.writeAsString(jsonEncode(inputHistory));
    });
    handleReqLocation();
    // Navigator.of(context).pop();
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
            onTap: () {},
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
      console(currentInput);
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
                  onSubmitted: handleSubmit,
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
            Icon(CupertinoIcons.search, color: mainColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Weather')),
      body: SingleChildScrollView(
        child: Consumer<WeatherModel>(
          builder: (context, provider, child) {
            return Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(16),
              child: Column(children: [searchInput()]),
            );
          },
        ),
      ),
    );
  }
}
