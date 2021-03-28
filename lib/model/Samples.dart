import 'dart:math';
import 'package:flutter/foundation.dart';

class Samples extends ChangeNotifier {
  double xMin, xMax;
  int intervals;
  double a;
  List<double> xs = [0.0, 10.0];
  List<double> ys = [-1.0, 1.0];
  bool showData = true;
  bool showTrend = true;
  bool showIMF = true;
  bool showControlPoints = false;

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

  void setShowData(bool v) {
    showData = v;
    notifyListeners();
  }

  void setShowTrend(bool v) {
    showTrend = v;
    notifyListeners();
  }

  void setShowIMF(bool v) {
    showIMF = v;
    notifyListeners();
  }

  void setShowControlPoints(bool v) {
    showControlPoints = v;
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
}
