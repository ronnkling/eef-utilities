import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../analysis/Decomposition.dart';
import '../model/DecompModel.dart';
import '../model/Samples.dart';
import '../spline/Spline.dart';
import 'uiHelper.dart';

class DecompView extends StatelessWidget {
  DecompView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final samples = context.read<Samples>();
    final decomp = context.watch<DecompModel>();
    return ExpansionTile(
        title: Text('Decompisition').bold(),
        children: <Widget>[
          ListView(children: <Widget>[
            Wrap(children: [
              OutlinedButton(
                child: const Text('Default Setting').bold(),
                onPressed: () {
                  decomp.setDefaults();
                },
              ).padding(horizontal: 20),
              RadioListTile<SplineType>(
                title: const Text('Cubic spline'),
                value: SplineType.cubicSpline,
                groupValue: decomp.splineType,
                onChanged: (value) => decomp.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Quintic spline'),
                value: SplineType.quinticSpline,
                groupValue: decomp.splineType,
                onChanged: (value) => decomp.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Cos series'),
                value: SplineType.cosSeries,
                groupValue: decomp.splineType,
                onChanged: (value) => decomp.splineType = value!,
              ).width(150),
              RadioListTile<SplineType>(
                title: const Text('Sin series'),
                value: SplineType.sinSeries,
                groupValue: decomp.splineType,
                onChanged: (value) => decomp.splineType = value!,
              ).width(150),
            ]),
            CheckboxListTile(
                value: decomp.useInflexion,
                onChanged: (value) => decomp.useInflexion = value!,
                title:
                    const Text('Use curvature (or change rate) for scaledown'),
                controlAffinity: ListTileControlAffinity.leading),
            CheckboxListTile(
                value: decomp.adjustEnds,
                onChanged: (value) => decomp.adjustEnds = value!,
                title: const Text('Adjust end points'),
                controlAffinity: ListTileControlAffinity.leading),
            ListTile(
              leading: Slider(
                value: decomp.maxComponents.toDouble(),
                label: '${decomp.maxComponents}',
                min: 1,
                max: 15,
                divisions: 14,
                onChanged: (value) => decomp.maxComponents = value.toInt(),
              ).width(400),
              title: const Text('Max components'),
            ),
            Wrap(children: [
              OutlinedButton(
                child: const Text('Run Decomposition').bold(),
                onPressed: () {
                  decomp.xs = samples.xs;
                  decomp.ys = samples.ys;
                  decomp.decompose();
                },
              ).padding(horizontal: 20),
              CheckboxListTile(
                      value: decomp.showData,
                      onChanged: (value) => decomp.showData = value!,
                      title: const Text('Data'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: decomp.showTrend,
                      onChanged: (value) => decomp.showTrend = value!,
                      title: const Text('Trend'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: decomp.showIMF,
                      onChanged: (value) => decomp.showIMF = value!,
                      title: const Text('IMF'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
              CheckboxListTile(
                      value: decomp.showControlPoints,
                      onChanged: (value) => decomp.showControlPoints = value!,
                      title: const Text('Control Points'),
                      controlAffinity: ListTileControlAffinity.leading)
                  .width(150),
            ]).padding(top: 20),
            _charts(decomp, samples).height(800),
          ]).height(1000),
        ]);
  }
}

ListView _charts(DecompModel decomp, Samples samples) {
  List<Widget> widgets = [];
  for (Decomposition d in decomp.decompList) {
    final data = data2Spots(d.xs, d.ys);
    final trend = data2Spots(d.xs, d.trend);
    final imf = data2Spots(d.xs, d.imf);
    final ctrlPoints = data2Spots(d.ctrlPoints.xE, d.ctrlPoints.yE);
    final chart = LineChart(
      LineChartData(
        borderData: FlBorderData(show: true),
        lineBarsData: [
          lineChartBarData(data, Colors.blueAccent, showChart: decomp.showData),
          lineChartBarData(trend, Colors.black, showChart: decomp.showTrend),
          lineChartBarData(imf, Colors.orangeAccent, showChart: decomp.showIMF),
          lineChartBarData(ctrlPoints, Colors.green,
              showChart: decomp.showControlPoints),
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
    widgets.add(chart);
  }
  return ListView(children: widgets);
}
