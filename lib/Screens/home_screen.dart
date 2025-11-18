import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../helper/index.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
  }

  handleReqLocation() async {
    String key = Provider.of<WeatherModel>(context, listen: false).apiKey;
    Response res = await dio.get(
      'https://restapi.amap.com/v3/geocode/geo?',
      queryParameters: {"key": key, "address": "广州", "city": "广州"},
    );
    console(res.data);
  }

  searchDialog() {
    Color mainColor = Theme.of(context).primaryColor;
    EdgeInsets padding = EdgeInsets.fromLTRB(16, 0, 16, 0);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: padding,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  padding: padding,
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
                ),
              ],
            ),
          ),
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
              'Search...',
              style: TextStyle(color: Colors.black, fontSize: 14),
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
