import 'dart:math';

import 'package:flutter/foundation.dart';

class Samples extends ChangeNotifier {
  double xMin, xMax;
  int intervals;
  double a;
  List<double> xs = [0, 1];
  List<double> ys = [0, 1];

  Samples(
      {this.xMin = 0.0, this.xMax = 100.0, this.intervals = 99, this.a = 0.2});

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

  void generateSamples() {
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
}
