import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

curveComponent() {
  // 定义图表数据 (x, y)
  List<FlSpot> spots = [
    FlSpot(1, 1),
    FlSpot(2, 2),
    FlSpot(3, 1),
    FlSpot(4, 2),
    FlSpot(5, 1),
    FlSpot(6, 2),
    FlSpot(7, 1),
  ];

  List<String> week = ['Mon', 'Tue', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'];

  return Container(
    height: 220,
    color: Colors.transparent,
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
                  touchedSpot.x.toString(),
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
            barWidth: 2, // 曲线宽度
            color: Colors.black, // 曲线颜色
            dotData: FlDotData(show: false), // 隐藏数据点上的小圆点
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                stops: [0.1, 0.9], // 停止位置：
                colors: [
                  Color.fromARGB(110, 44, 0, 165), // 渐变起始颜色 (上方)
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
          // 隐藏顶部、底部和右侧标题
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toDouble()) {
                  case 1:
                    text = week[0];
                    break;
                  case 2:
                    text = week[1];
                    break;
                  case 3:
                    text = week[2];
                    break;
                  case 4:
                    text = week[3];
                    break;
                  case 5:
                    text = week[4];
                    break;
                  case 6:
                    text = week[5];
                    break;
                  case 7:
                    text = week[6];
                    break;
                }
                return Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    text.toString(),
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
                String text;
                switch (value.toInt()) {
                  case 1:
                    text = '-10°';
                    break;
                  case 2:
                    text = '0°';
                    break;
                  case 3:
                    text = '10°';
                    break;
                  default:
                    text = ''; // 其他数值不显示标签
                    break;
                }
                return Text(
                  text.toString(),
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
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color.fromARGB(255, 204, 193, 221), // 线的颜色
              strokeWidth: 3, // 线的粗细
            );
          },
        ),

        // 5. 范围配置 (可选，如果不设置，fl_chart会根据数据自动调整)
        minY: 0,
        maxY: 4,
      ),
    ),
  );
}
