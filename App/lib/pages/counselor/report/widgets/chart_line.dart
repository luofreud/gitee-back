import 'dart:math' as Math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartLineWidget extends StatelessWidget {
  const ChartLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Math.Random random = Math.Random();
    return LineChart(
      LineChartData(
        // 1. 定义网格线背景
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xffEDEDED),
              strokeWidth: 1,
              dashArray: [2, 2], // 虚线效果
            );
          },
        ),
        // 2. 定义标题轴 (X轴和Y轴的文字)
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10, color: Color(0xffA6A6A6)),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: TextStyle(fontSize: 10, color: Color(0xffA6A6A6)),
                );
              },
            ),
          ),
        ),
        // 3. 定义边框
        borderData: FlBorderData(show: false),
        // 4. 触摸交互
        lineTouchData: LineTouchData(
          enabled: true, // 开启触摸
          handleBuiltInTouches: true, // 启用内置的高亮效果（点击时点变大）
          // 自定义触摸点样式
          getTouchedSpotIndicator: (barData, indicators) {
            return indicators.map((index) {
              return TouchedSpotIndicatorData(
                // 控制垂直线 (The Vertical Line)
                FlLine(
                  color: Color(0xff6969FF),
                  strokeWidth: 2, // 【关键点】这里设置垂直线的粗细
                  // dashArray: [5, 5], // 可选：设置为虚线 [实线长度, 间隔长度]
                ),
                // 控制点 (FlDotData)
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, idx) =>
                      FlDotCirclePainter(
                        radius: 5,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Color(0xff6969FF),
                      ),
                ),
              );
            }).toList();
          },
          // 触摸弹出框样式
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(8),
            getTooltipColor: (spot) {
              return Colors.white;
            },
            // 基础圆角
            tooltipBorderRadius: const BorderRadius.all(Radius.circular(8)),

            tooltipBorder: BorderSide(
              color: Color(0xff6969FF).withAlpha(50),
              width: 1,
            ),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.x}\n', // 显示的内容
                  TextStyle(color: Color(0xff383838), fontSize: 12),
                  textAlign: TextAlign.left,
                  children: [
                    TextSpan(
                      text: '点赞：${spot.y}',
                      style: TextStyle(color: Color(0xff757575), fontSize: 12),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        // 5. 绘制曲线
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(20, (i) {
              return FlSpot(
                i.toDouble(),
                double.parse((random.nextDouble() * 100).toStringAsFixed(2)),
              );
              // return FlSpot(i.toDouble(), 50 + 40 * Math.sin(i / 5));
            }),
            color: Color(0xff6969FF),
            barWidth: 1,
            isCurved: false,
            // 开启平滑曲线
            curveSmoothness: 0.1,
            dotData: FlDotData(show: false),
            //数据点
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.7],
                colors: [
                  Color(0xff2A82E4).withAlpha(50),
                  Color(0xff2A82E4).withAlpha(0),
                ],
              ),
            ), // 是否显示下方填充区域
          ),
        ],
      ),
    );
  }
}
