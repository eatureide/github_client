import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import '../models/weather.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Hourly extends StatefulWidget {
  final List<HourItem>? hourlyList;
  const Hourly({super.key, required List<HourItem> this.hourlyList});

  @override
  State<Hourly> createState() => _Hourly();
}

class _Hourly extends State<Hourly> {
  Widget itemComponent(HourItem item, int index) {
    String path = 'assets/weather/${item.icon}-fill.svg';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              index == 0 ? 'Now' : '${item.hour} ',
              style: TextStyle(fontSize: 18),
            ),
            index == 0
                ? Text('')
                : Text(
                    item.hour <= 12 ? 'AM' : 'PM',
                    style: TextStyle(fontSize: 12),
                  ),
          ],
        ),
        SizedBox(height: 10),

        // Icon(CupertinoIcons.cloud_sun_fill, size: 38),
        SvgPicture.asset(
          path,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),

        SizedBox(height: 10),
        Text('${item.temp}°', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(CupertinoIcons.clock, size: 14),
                ),
                SizedBox(width: 12),
                Text('Hourly forecast'),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (() {
                if (widget.hourlyList == null || widget.hourlyList!.isEmpty) {
                  return [Text('')];
                }
                return widget.hourlyList!.sublist(0, 6).asMap().entries.map((
                  entry,
                ) {
                  int index = entry.key;
                  return itemComponent(widget.hourlyList![index], index);
                }).toList();
              })(),
            ),
          ],
        ),
      ),
    );
  }
}
