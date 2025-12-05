import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import '../models/weather.dart';

class ChanceOfRain extends StatefulWidget {
  final List<HourItem>? hourlyList;
  const ChanceOfRain({super.key, required List<HourItem> this.hourlyList});

  @override
  State<ChanceOfRain> createState() => _ChanceOfRain();
}

class _ChanceOfRain extends State<ChanceOfRain> {
  itemComponent(HourItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${item.hour} ${item.hour >= 12 ? 'PM' : 'AM'}'),
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: LinearProgressIndicator(
              value: double.parse(item.pop) / 100,
              minHeight: 28,
              backgroundColor: Color.fromARGB(255, 249, 237, 254),
              color: Color.fromARGB(255, 134, 38, 208),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          SizedBox(width: 12),
          SizedBox(width: 25, child: Text('${item.pop}%')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
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
                  child: Icon(CupertinoIcons.cloud_rain, size: 14),
                ),
                Text('Changce of Rain', style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 24),

            widget.hourlyList!.isEmpty
                ? Text('')
                : Column(
                    children: widget.hourlyList!.sublist(0, 6).map((item) {
                      return itemComponent(item) as Widget;
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
