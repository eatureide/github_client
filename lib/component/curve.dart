import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';

class CurveComponent extends StatefulWidget {
  final String tempMax;
  final String tempMin;
  final List<DayItem>? daysList;

  const CurveComponent({
    super.key,
    required this.tempMax,
    required this.tempMin,
    required this.daysList,
  });

  @override
  State<CurveComponent> createState() => _CurveComponent();
}

class _CurveComponent extends State<CurveComponent> {
  // 定义图表数据 (x, y)
  List<FlSpot> spots = [
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
    FlSpot(7, 0),
  ];

  List<String> week = ['Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    setState(() {
      Future.delayed(Duration(milliseconds: 300), () {
        spots = [
          FlSpot(1, widget.daysList![0].tempMaxInt.toDouble()),
          FlSpot(2, widget.daysList![1].tempMaxInt.toDouble()),
          FlSpot(3, widget.daysList![2].tempMaxInt.toDouble()),
          FlSpot(4, widget.daysList![3].tempMaxInt.toDouble()),
          FlSpot(5, widget.daysList![4].tempMaxInt.toDouble()),
          FlSpot(6, widget.daysList![5].tempMaxInt.toDouble()),
          FlSpot(7, widget.daysList![6].tempMaxInt.toDouble()),
        ];
      });
    });
  }

  @override
  didUpdateWidget(covariant CurveComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color.fromARGB(0, 0, 0, 0),
      child: LineChart(
        duration: Duration(milliseconds: 1000), // 设置动画持续时间为 800ms
        curve: Curves.easeInOut, // 设置动画曲线为缓入缓出

        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            // 2. 配置提示框 (Tooltip) 样式
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                // 返回自定义的指示器数据
                return TouchedSpotIndicatorData(
                  // 配置指示线 (这条线是垂直的，样式由 FlLine 决定)
                  FlLine(
                    color: Color.fromARGB(255, 32, 1, 91), // 指示线颜色
                    strokeWidth: 2, // 线的粗细
                    dashArray: [4, 4], // 设置为虚线 [实线长度, 空白长度]
                  ),

                  // 配置指示点（触摸点上显示的小圆点）
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 7.0, // 指示点圆圈半径
                        color: Color.fromARGB(255, 32, 1, 91), // 指示线颜色
                        strokeWidth: 3, // 边框宽度
                        strokeColor: Colors.white, // 边框颜色
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (LineBarSpot touchedSpot) {
                return Colors.white;
              },
              tooltipRoundedRadius: 8, // 提示框圆角
              fitInsideHorizontally: true, // 确保提示框在图表内
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                    widget.daysList![touchedSpot.x.toInt() - 1].tempMax,
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          // 1. 数据配置
          lineBarsData: [
            LineChartBarData(
              spots: spots, // 使用上面定义的数据点
              isCurved: true, // 启用曲线平滑效果
              barWidth: 3, // 曲线宽度
              color: Colors.black, // 曲线颜色
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  // 例如：只显示最后一个点
                  return spot.x == barData.spots.last.x;
                },
                getDotPainter: (spot, percent, barData, index) {
                  // 2. 使用 FlDotCirclePainter 复刻你在交互时定义的样式
                  return FlDotCirclePainter(
                    radius: 7.0, // 半径
                    color: const Color.fromARGB(255, 32, 1, 91), // 填充颜色
                    strokeWidth: 3, // 边框宽度
                    strokeColor: Colors.white, // 边框颜色
                  );
                },
              ), // 隐藏数据点上的小圆点
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  stops: [0.5, 9.5], // 停止位置：
                  colors: [
                    Color.fromARGB(100, 44, 0, 165), // 渐变起始颜色 (上方)
                    Color.fromARGB(20, 44, 0, 165), // 渐变结束颜色 (下方)
                  ],
                  begin: Alignment.topCenter, // 渐变从顶部开始
                  end: Alignment.bottomCenter, // 渐变到底部结束
                ),
              ),
            ),
          ],

          // 2. 标题/轴线配置 (重点修改这里)
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  String dateStr = widget.daysList![value.toInt() - 1].fxDate;
                  DateTime date = DateTime.parse(dateStr);
                  String weekdayAbbreviation = DateFormat('E').format(date);
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      weekdayAbbreviation,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),

            // 左侧纵轴标题
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40, // 为标签预留的宽度
                showTitles: true, // 必须设置为 true 才能显示标签
                getTitlesWidget: (value, meta) {
                  String text = value.toInt().toString();
                  if (value == 0) text = '';
                  if (value >= double.parse(widget.tempMax) + 20) text = '';
                  return Text(
                    text == '' ? '' : '$text°',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),

          // 3. 边框配置
          borderData: FlBorderData(show: false),

          // 4. 网格线配置
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            // 可选：进一步自定义水平网格线样式
            getDrawingHorizontalLine: (value) => FlLine(
              color: Color.fromARGB(255, 204, 193, 221), // 线的颜色
              strokeWidth: 3, // 线的粗细
            ),
          ),

          // 5. 范围配置 (可选，如果不设置，fl_chart会根据数据自动调整)
          minY: 0,
          maxY: widget.tempMax == '' ? 0 : double.parse(widget.tempMax) + 20,
        ),
      ),
    );
  }
}
