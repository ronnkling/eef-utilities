import 'dart:math';

import 'package:flutter/foundation.dart';

class Samples extends ChangeNotifier {
  double xMin, xMax;
  int intervals;
  double a;
  List data = [
    {'x': 0.0, 'y': 0.0},
    {'x': 1.0, 'y': 1.0}
  ];

  Samples(
      {this.xMin = 0.0, this.xMax = 100.0, this.intervals = 99, this.a = 0.2});

  void setXMin(double v) {
    xMin = v;
    print('xMin=$xMin\n');
    notifyListeners();
  }

  void setXMax(double v) {
    xMax = v;
    print('xMax=$xMax\n');
    notifyListeners();
  }

  void setIntervals(int v) {
    intervals = v;
    print('intervals=$intervals\n');
    notifyListeners();
  }

  void setA(double v) {
    a = v;
    print('a=$a\n');
    notifyListeners();
  }

  void generateData() {
    double dx = (xMax - xMin) / intervals;
    int n = intervals + 1;
    data = List.filled(n, {'x': 0.0, 'y': 0.0});
    var rand = Random();
    data[0]['x'] = xMin;
    data[0]['y'] = 2.0 * (rand.nextDouble() - 0.5);
    for (int i = 1; i < n; i++) {
      data[i] = {
        'x': data[i - 1]['x'] + dx,
        'y': data[i - 1]['y'] + 2.0 * a * (rand.nextDouble() - 0.5)
      };
    }
    notifyListeners();
  }
}
