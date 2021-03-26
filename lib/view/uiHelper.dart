import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

List<FlSpot> data2Spots(List<double> xs, List<double> ys) {
  final n = min(xs.length, ys.length);
  var spots = List<FlSpot>.filled(n, FlSpot(0.0, 0.0));
  for (int i = 0; i < n; i++) {
    spots[i] = FlSpot(xs[i], ys[i]);
  }
  return spots;
}

LineChartBarData lineChartBarData(List<FlSpot> spots, Color color,
    {bool showChart = true, bool showDot = false}) {
  return LineChartBarData(
    spots: spots,
    show: showChart,
    isCurved: false,
    barWidth: 1,
    colors: [
      color,
    ],
    dotData: FlDotData(show: showDot),
  );
}
