import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/Samples.dart';

class SamplesPage extends StatelessWidget {
  SamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final samples = context.watch<Samples>();
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 80),
            const Text('y[0] = rand(),  y[i+1] = y[i] + a * rand()'),
            SizedBox(width: 300),
            OutlinedButton(
              child: const Text('Refresh'),
              onPressed: () {
                samples.generateData();
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '${samples.a}'),
                decoration: InputDecoration(labelText: 'a'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSubmitted: (value) {
                  samples.setA(double.parse(value));
                },
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '${samples.xMin}'),
                decoration: InputDecoration(labelText: 'Xmin'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSubmitted: (value) {
                  samples.setXMin(double.parse(value));
                },
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '${samples.xMax}'),
                decoration: InputDecoration(labelText: 'Xmax'),
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSubmitted: (value) {
                  samples.setXMax(double.parse(value));
                },
              ),
            ),
            SizedBox(width: 80),
            Container(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: '${samples.intervals}'),
                decoration: InputDecoration(labelText: 'Intervals'),
                keyboardType: TextInputType.numberWithOptions(),
                onSubmitted: (value) {
                  samples.setIntervals(int.parse(value));
                },
              ),
            ),
          ],
        ),
        Container(
          width: 400,
          height: 300,
          padding: EdgeInsets.all(30),
          child: LineChart(
            LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
              LineChartBarData(
                spots: _getSpots(samples.xs, samples.ys),
                isCurved: false,
                barWidth: 1,
                colors: [
                  Colors.blue,
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }
}

List<FlSpot> _getSpots(List<double> xs, List<double> ys) {
  final n = min(xs.length, ys.length);
  var spots = List<FlSpot>.filled(n, FlSpot(0.0, 0.0));
  for (int i = 0; i < n; i++) {
    spots[i] = FlSpot(xs[i], ys[i]);
  }
  return spots;
}
