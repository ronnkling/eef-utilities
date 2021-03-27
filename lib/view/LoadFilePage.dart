import 'dart:math';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class LoadFilePage extends StatelessWidget {
  // Generate some dummy data for the cahrt

  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  final List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: dummyData1,
            isCurved: true,
            barWidth: 1,
            colors: [
              Colors.red,
            ],
          ),
          LineChartBarData(
            spots: dummyData2,
            isCurved: true,
            barWidth: 1,
            colors: [
              Colors.orange,
            ],
          ),
          LineChartBarData(
            spots: dummyData3,
            isCurved: false,
            barWidth: 1,
            colors: [
              Colors.blue,
            ],
          )
        ],
      ),
    ).width(800).padding(all: 20);
  }
}
