import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';

class Days extends StatefulWidget {
  const Days({super.key});

  @override
  State<Days> createState() => _Days();
}

class _Days extends State<Days> {
  buildItem() {
    return Container(
      height: 84,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('3°', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cloudy and Sunny',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 73, 70, 73),
                      ),
                    ),
                    Text('-2°', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 2,
            height: 46,
            color: Color.fromARGB(255, 75, 69, 77),
          ),
          SizedBox(width: 12),
          Icon(CupertinoIcons.cloud_sun_fill, size: 46),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          buildItem(),
          buildItem(),
          buildItem(),
          buildItem(),
          buildItem(),
          buildItem(),
          buildItem(),
          buildItem(),
        ],
      ),
    );
  }
}
