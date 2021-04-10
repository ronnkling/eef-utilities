import 'dart:math';
import 'package:flutter/foundation.dart';

class Samples extends ChangeNotifier {
  double xMin, xMax;
  int intervals;
  double a;
  List<double> xs = [0.0, 10.0];
  List<double> ys = [-1.0, 1.0];

  String fileName = '';
  String? xField;
  String? yField;
  List<String> fieldNames = [];
  Map<String, int> nameToIndex = {};
  List<List<dynamic>> fieldValues = [];
  List<dynamic>? xList;

  Samples(
      {this.xMin = 0.0, this.xMax = 10.0, this.intervals = 100, this.a = 0.2});

  void setXMin(double v) {
    xMin = v;
    notifyListeners();
  }

  void setXMax(double v) {
    xMax = v;
    notifyListeners();
  }

  void setIntervals(int v) {
    intervals = v;
    notifyListeners();
  }

  void setA(double v) {
    a = v;
    notifyListeners();
  }

  void setFileName(String v) {
    fileName = v;
    notifyListeners();
  }

  void setXField(String v) {
    if (v == yField) return;
    xField = v;
    notifyListeners();
  }

  void setYField(String v) {
    if (v == xField) return;
    yField = v;
    notifyListeners();
  }

  void generateData() {
    double dx = (xMax - xMin) / intervals;
    int n = intervals + 1;
    xs = List.filled(n, 0.0);
    ys = List.filled(n, 0.0);
    var rand = Random();
    xs[0] = xMin;
    ys[0] = 2.0 * (rand.nextDouble() - 0.5);
    for (int i = 1; i < n; i++) {
      xs[i] = xs[i - 1] + dx;
      ys[i] = ys[i - 1] + 2.0 * a * (rand.nextDouble() - 0.5);
    }
    notifyListeners();
  }

  updateFields(List<List<dynamic>> rows) {
    fieldNames = rows[0].map((e) => e.toString()).toList();
    nameToIndex = {};
    for (int i = 0; i < fieldNames.length; i++) {
      nameToIndex[fieldNames[i]] = i;
      // print('type of ${fieldNames[i]} is ${rows[1][i].runtimeType}');
    }
    fieldValues = [];
    for (int i = 1; i < rows.length; i++) {
      if (rows[i].length == fieldNames.length) {
        fieldValues.add(rows[i]);
      }
    }
    xField = null;
    yField = null;
    notifyListeners();
  }

  List<dynamic> fieldData(String name) {
    List<dynamic> column = [];
    final index = nameToIndex[name]!;
    for (final row in fieldValues) {
      column.add(row[index]);
    }
    return column;
  }

  List<String> numFieldNames() {
    List<String> names = [];
    for (int i = 0; i < fieldNames.length; i++) {
      final type = fieldValues[0][i].runtimeType;
      if (type == int || type == double) {
        names.add(fieldNames[i]);
      }
    }
    return names;
  }

  bool isFieldNumeric(String? name) {
    if (name == null) return false;
    final idx = nameToIndex[name]!;
    final type = fieldValues[0][idx].runtimeType;
    return (type == int || type == double);
  }

  void updateXsYs() {
    final xIndex = nameToIndex[xField]!;
    final n = fieldValues.length;
    if (xField == null || !isFieldNumeric(xField)) {
      xs = [for (int i = 0; i < n; i++) i.toDouble()];
      xList = xField == null ? null : fieldData(xField!);
    } else {
      xs = [for (int i = 0; i < n; i++) fieldValues[i][xIndex] as double];
      xList = null;
    }
    xMin = xs[0];
    xMax = xs[n - 1];
    final yIndex = nameToIndex[yField]!;
    ys = [for (int i = 0; i < n; i++) fieldValues[i][yIndex] as double];
    notifyListeners();
  }
}
