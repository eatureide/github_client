import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleWeatherChart extends StatefulWidget {
  const SimpleWeatherChart({super.key});

  @override
  State<SimpleWeatherChart> createState() => _SimpleWeatherChart();
}

class _SimpleWeatherChart extends State<SimpleWeatherChart> {
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
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        spots = [
          FlSpot(1, 1),
          FlSpot(2, 2),
          FlSpot(3, 1),
          FlSpot(4, 2),
          FlSpot(5, 1),
          FlSpot(6, 2),
          FlSpot(7, 1),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 237, 254),
        appBar: AppBar(title: Text('Demo')),
        body: Container(
          height: 240,
          color: Colors.transparent,
          // color: Colors.red,
          child: LineChart(
            duration: Duration(milliseconds: 1000), // 设置动画持续时间为 800ms
            curve: Curves.easeInOut, // 设置动画曲线为缓入缓出
            LineChartData(
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
                        Color.fromARGB(152, 44, 0, 165), // 渐变起始颜色 (上方)
                        Color.fromARGB(58, 43, 0, 165), // 渐变结束颜色 (下方)
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
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

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
                          style: TextStyle(fontSize: 18),
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
                        style: TextStyle(fontSize: 18),
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
        ),
      ),
    );
  }
}
