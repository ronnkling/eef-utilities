import 'package:tuple/tuple.dart';

enum SplineFn { cubicSpline, quinticSpline, cosSeries, sinSeries }

abstract class Spline {
  Tuple2<double, int> value(double x, {int k = 0});
  Tuple2<double, int> derivative(double x, {int k = 0});
  Tuple2<double, int> derivative2(double x, {int k = 0});
  Tuple2<double, int> derivative3(double x, {int k = 0});
  List<double> values(List<double> xs);
  List<double> derivatives(List<double> xs);
  List<double> derivatives2(List<double> xs);
  List<double> derivatives3(List<double> xs);
  void outputFormula(StringSink out);
  void outputDerivative(StringSink out);
}

// return the value relative to the segmnent start, and segment index
// xx the segment coordinate, k is search start segment index
Tuple2<double, int> findSegment(List<double> xx, double x, {int k = 0}) {
  int n = xx.length;
  if (x < xx[0]) {
    k = 0;
  } else if (x > xx[n - 1]) {
    k = n - 1;
  } else {
    // get the correct segment k
    for (int i = k; i < n; ++i) {
      if (x > xx[i + 1])
        k++;
      else
        break;
    }
  }
  return Tuple2(x - xx[k], k);
}
