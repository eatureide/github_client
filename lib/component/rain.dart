import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';

class ChanceOfRain extends StatefulWidget {
  const ChanceOfRain({super.key});

  @override
  State<ChanceOfRain> createState() => _ChanceOfRain();
}

class _ChanceOfRain extends State<ChanceOfRain> {
  itemComponent() {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('7PM'),
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: LinearProgressIndicator(
              value: 0.5,
              minHeight: 28,
              backgroundColor: Color.fromARGB(255, 249, 237, 254),
              color: Color.fromARGB(255, 134, 38, 208),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          SizedBox(width: 12),
          Text('27%'),
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
            SizedBox(height: 28),
            itemComponent(),
            itemComponent(),
            itemComponent(),
            itemComponent(),
          ],
        ),
      ),
    );
  }
}
