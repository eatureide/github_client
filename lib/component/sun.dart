import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';
import '../models/weather.dart';
import '../utils/index.dart';

class SunRiseAndSet extends StatefulWidget {
  final List<DayItem>? daysList;
  const SunRiseAndSet({super.key, required this.daysList});

  @override
  State<SunRiseAndSet> createState() => _SunRiseAndSet();
}

class _SunRiseAndSet extends State<SunRiseAndSet> {
  buildItem({
    required String title,
    required String subTitle,
    required IconData icon,
  }) {
    DateTime result = combineTimeWithToday(subTitle);
    String hourStr = timeFormatAddZero(result.hour);
    String minuteStr = timeFormatAddZero(result.minute);
    return Container(
      height: 65,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 16),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                '$hourStr:$minuteStr ${result.hour >= 12 ? 'PM' : 'AM'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.daysList == null) return Text('');
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: buildItem(
              title: 'Sunrise',
              subTitle: widget.daysList![0].sunrise,
              icon: CupertinoIcons.moon_stars,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: buildItem(
              title: 'Sunset',
              subTitle: widget.daysList![0].sunset,
              icon: CupertinoIcons.sun_max,
            ),
          ),
        ],
      ),
    );
  }
}
