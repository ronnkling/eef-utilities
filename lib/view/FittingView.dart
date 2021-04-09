import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/Samples.dart';
import '../spline/Spline.dart';
import '../model/FittingModel.dart';
import 'uiHelper.dart';

class FittingView extends StatelessWidget {
  FittingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fitting = context.watch<FittingModel>();
    final samples = context.read<Samples>();
    return ExpansionTile(
        title: Text('Curve Fitting').bold(),
        children: <Widget>[
          ListView(children: <Widget>[
            Row(children: [
              OutlinedButton(
                child: const Text('Default Setting').bold(),
                onPressed: () {
                  fitting.setDefaults();
                },
              ).padding(horizontal: 20),
              RadioListTile<SplineType>(
                title: const Text('Cubic spline'),
                value: SplineType.cubicSpline,
                groupValue: fitting.splineType,
                onChanged: (value) => fitting.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Quintic spline'),
                value: SplineType.quinticSpline,
                groupValue: fitting.splineType,
                onChanged: (value) => fitting.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Cos series'),
                value: SplineType.cosSeries,
                groupValue: fitting.splineType,
                onChanged: (value) => fitting.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Sin series'),
                value: SplineType.sinSeries,
                groupValue: fitting.splineType,
                onChanged: (value) => fitting.splineType = value!,
              ).width(150),
            ]),
            CheckboxListTile(
                value: fitting.useCurvature,
                onChanged: (value) => fitting.useCurvature = value!,
                title: const Text(
                    'Use curvature (or change rate) for split intervals'),
                controlAffinity: ListTileControlAffinity.leading),
            ListTile(
              leading: Slider(
                value: fitting.splitLevels.toDouble(),
                label: '${fitting.splitLevels}',
                min: 1,
                max: 9,
                divisions: 2,
                onChanged: (value) => fitting.splitLevels = value.toInt(),
              ).width(400),
              title: const Text('Max split levels'),
            ),
            Row(children: [
              OutlinedButton(
                child: const Text('Rerun').bold(),
                onPressed: () {
                  fitting.xs = samples.xs;
                  fitting.ys = samples.ys;
                  fitting.fitCurves();
                },
              ).padding(horizontal: 20),
              CheckboxListTile(
                      value: fitting.showData,
                      onChanged: (value) => fitting.showData = value!,
                      title: const Text('Data'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: fitting.showCurve,
                      onChanged: (value) => fitting.showCurve = value!,
                      title: const Text('Curve'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: fitting.showDiff,
                      onChanged: (value) => fitting.showDiff = value!,
                      title: const Text('Diff'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: fitting.showControlPoints,
                      onChanged: (value) => fitting.showControlPoints = value!,
                      title: const Text('Control Points'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
            ]).padding(top: 20),
            _chart(fitting, samples),
          ]).height(600),
        ]).height(800);
  }
}

Widget _chart(FittingModel fitting, Samples samples) {
  if (fitting.fittingList.length < fitting.currentLevel) return Container();
  final model = fitting.fittingList[fitting.currentLevel - 1];
  final data = data2Spots(samples.xs, samples.ys);
  final curve = data2Spots(samples.xs, model.curve);
  final diff = data2Spots(samples.xs, model.diff);
  final n = model.controlIndices.length;
  final xc = List<double>.filled(n, 0.0);
  final yc = List<double>.filled(n, 0.0);
  for (int i = 0; i < n; i++) {
    xc[i] = samples.xs[model.controlIndices[i]];
    yc[i] = samples.ys[model.controlIndices[i]];
  }
  final ctrlPoints = data2Spots(xc, yc);
  return LineChart(
    LineChartData(
      borderData: FlBorderData(show: true),
      lineBarsData: [
        lineChartBarData(data, Colors.blueAccent, showChart: fitting.showData),
        lineChartBarData(curve, Colors.black, showChart: fitting.showCurve),
        lineChartBarData(diff, Colors.orangeAccent,
            showChart: fitting.showDiff),
        lineChartBarData(ctrlPoints, Colors.green,
            showChart: fitting.showControlPoints),
      ],
      titlesData: FlTitlesData(
        bottomTitles: bottomTitles(samples.xMin, samples.xMax),
      ),
      gridData: FlGridData(
        drawVerticalLine: true,
        verticalInterval: (samples.xMax - samples.xMin) / 10,
        drawHorizontalLine: true,
        horizontalInterval: samples.a,
      ),
      lineTouchData: LineTouchData(enabled: false),
    ),
  ).width(400).height(300).padding(all: 30);
}
