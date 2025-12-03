import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';

class Hourly extends StatefulWidget {
  const Hourly({super.key});

  @override
  State<Hourly> createState() => _Hourly();
}

class _Hourly extends State<Hourly> {
  itemComponent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('10', style: TextStyle(fontSize: 18)),
            Text('AM', style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(height: 4),
        Icon(CupertinoIcons.cloud_sun_fill, size: 38),
        SizedBox(height: 4),
        Text('10°', style: TextStyle(fontSize: 22)),
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
              children: [
                itemComponent(),
                itemComponent(),
                itemComponent(),
                itemComponent(),
                itemComponent(),
                itemComponent()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
