import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:csv/csv.dart';
import '../model/Samples.dart';
import 'uiHelper.dart';

class CsvFileView extends StatelessWidget {
  CsvFileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final samples = context.watch<Samples>();
    return ExpansionTile(
      title: Text('Data').bold(),
      children: <Widget>[
        ListView(
          children: <Widget>[
            Wrap(
              children: <Widget>[
                OutlinedButton(
                  child: const Text('Open File').bold(),
                  onPressed: () async {
                    FilePickerCross csvFile =
                        await FilePickerCross.importFromStorage(
                            type: FileTypeCross.custom, fileExtension: 'csv');
                    samples.setFileName(csvFile.fileName);
                    final rows = CsvToListConverter(eol: '\n')
                        .convert(csvFile.toString());
                    samples.updateFields(rows);
                  },
                ),
                const Text('File Name:').padding(left: 30),
                Text(samples.fileName).bold().padding(left: 30),
                const Text('X field:').padding(left: 30),
                DropdownButton(
                  value: samples.xField,
                  items: samples.fieldNames
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? value) => samples.setXField(value!),
                ).padding(left: 30),
                const Text('Y field:').padding(left: 30),
                DropdownButton(
                  value: samples.yField,
                  items: samples
                      .numFieldNames()
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? value) => samples.setYField(value!),
                ).padding(left: 30),
              ],
            ).padding(left: 80, top: 10),
            Row(children: <Widget>[]).padding(left: 80, top: 20),
            LineChart(
              LineChartData(
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  lineChartBarData(
                      data2Spots(samples.xs, samples.ys), Colors.blueAccent,
                      showChart: true),
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
            ).height(300).padding(all: 30),
          ],
        ).height(450).alignment(Alignment.topCenter),
      ],
    );
  }
}
