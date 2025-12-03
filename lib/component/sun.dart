import 'package:flutter/material.dart';
import 'package:github_clint_app/theme.dart';
import 'package:flutter/cupertino.dart';

class SunRiseAndSet extends StatefulWidget {
  const SunRiseAndSet({super.key});

  @override
  State<SunRiseAndSet> createState() => _SunRiseAndSet();
}

class _SunRiseAndSet extends State<SunRiseAndSet> {
  buildItem({required String title, required IconData icon}) {
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
              Text('4:20PM', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: buildItem(title: 'Sunrise', icon: CupertinoIcons.moon_stars),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: buildItem(title: 'Sunset', icon: CupertinoIcons.sun_max),
          ),
        ],
      ),
    );
  }
}
