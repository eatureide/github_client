import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import '../models/weather.dart';
import '../utils/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Days extends StatefulWidget {
  final List<DayItem>? daysList;
  const Days({super.key, required this.daysList});

  @override
  State<Days> createState() => _Days();
}

class _Days extends State<Days> {
  buildItem(DayItem item) {
    DateTime date = DateTime.parse(item.fxDate);
    String month = monthAbbreviationMap[date.month.toInt()] ?? '';
    String path = 'assets/weather/${item.iconDay}.svg';
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
                      '$month, ${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${item.tempMax}°', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     '${weatherList[item.textDay]??item.textDay}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 73, 70, 73),
                      ),
                    ),
                    Text('${item.tempMin}°', style: TextStyle(fontSize: 16)),
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
          SvgPicture.asset(path, width: 46, height: 46),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.daysList == null) {
      return Text('');
    }
    print(widget.daysList);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: widget.daysList!.map((item) {
          return buildItem(item) as Widget;
        }).toList(),
      ),
    );
  }
}
