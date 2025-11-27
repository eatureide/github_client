import 'package:flutter/material.dart';

class StickyHeaderExample extends StatelessWidget {
  const StickyHeaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // 1. 顶部内容 (如果需要的话，比如一个大的图片或AppBar)
          // SliverList(
          //   delegate: SliverChildListDelegate([
          //     Container(
          //       height: 300,
          //       color: Colors.blueGrey,
          //       alignment: Alignment.center,
          //       child: Text(
          //         '顶部内容区',
          //         style: TextStyle(color: Colors.white, fontSize: 24),
          //       ),
          //     ),
          //   ]),
          // ),

          // 2. 粘性 Header (吸顶元素)
          SliverPersistentHeader(
            pinned: true, // **关键属性**: 设置为 true 实现吸顶效果
            delegate: _StickyHeaderDelegate(
              minHeight: 60.0, // Header 缩小时的最小高度
              maxHeight:
                  120.0, // Header 展开时的最大高度 (可以设置为与 minHeight 相同，实现固定高度的粘性)
              child: Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  '我是粘性 Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 3. 滚动内容区
          // SliverList(
          //   delegate: SliverChildBuilderDelegate((
          //     BuildContext context,
          //     int index,
          //   ) {
          //     return ListTile(title: Text('列表项 $index'));
          //   }, childCount: 50),
          // ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 1000,
                color: Colors.blueGrey,
                alignment: Alignment.center,
                child: Text(
                  '顶部内容区',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// 继承自 SliverPersistentHeaderDelegate 的类，用于实现 Header 的布局和变化逻辑
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  // 核心方法: 构建 Header 的实际内容
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  // 是否需要重新构建 Header。通常保持为 true 或在需要时进行更复杂的判断。
  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
