import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../analysis/Fitting.dart';
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
        title: Row(children: <Widget>[
          Text('Curve Fitting').bold(),
          Spacer(),
          OutlinedButton(
            child: const Text('Help').bold(),
            onPressed: () async {
              await _showFittingHelp(context);
            },
          ),
        ]),
        children: <Widget>[
          ListView(children: <Widget>[
            Wrap(children: [
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
                max: 10,
                divisions: 9,
                onChanged: (value) => fitting.splitLevels = value.toInt(),
              ).width(400),
              title: const Text('Max split levels'),
            ),
            Wrap(children: [
              OutlinedButton(
                child: const Text('Run Curve Fitting').bold(),
                onPressed: () {
                  fitting.xs = samples.xs;
                  fitting.ys = samples.ys;
                  fitting.fitCurves();
                },
              ).padding(horizontal: 20),
              OutlinedButton(
                child: const Text('Export Functions').bold(),
                onPressed: () async {
                  await _showCurveFunctions(context, fitting.fittingList);
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
              DropdownButton(
                value: fitting.currentLevel,
                items: [for (int i = 1; i <= fitting.splitLevels; i++) i]
                    .map((int value) => DropdownMenuItem<int>(
                        value: value, child: Text('Level $value')))
                    .toList(),
                onChanged: (int? value) => fitting.currentLevel = value!,
              ).padding(horizontal: 20),
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
        bottomTitles:
            bottomTitles(samples.xMin, samples.xMax, xList: samples.xList),
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

Future<void> _showFittingHelp(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Curve Fitting Help'),
        content: SingleChildScrollView(
          child: Text(
            '''Curve Fitting
help content''',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showCurveFunctions(
    BuildContext context, List<Fitting> fittingList) {
  if (fittingList.length < 1) return Future.value();
  final buffer = StringBuffer();
  for (int i = 0; i < fittingList.length; i++) {
    var spline = fittingList[i].gCurve;
    buffer.writeln('# level ${i + 1}');
    spline.outputDerivative(buffer);
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Curve Functions'),
        content: SingleChildScrollView(
          child: TextField(
            controller: TextEditingController(
              text: buffer.toString(),
            ),
            maxLines: 40,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
