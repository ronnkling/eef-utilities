import 'package:tuple/tuple.dart';
import 'Spline.dart';

class Linear implements Spline {
  final List<double> X;
  final List<double> Y;
  final int N;
  late final List<double> C;

  Linear(this.X, this.Y) : N = X.length {
    C = List.filled(N, 0.0);
    int m = N - 1;
    for (int i = 0; i < m; ++i) {
      C[i] = (Y[i + 1] - Y[i]) / (X[i + 1] - X[i]);
    }
    C[m] = C[m - 1];
  }

  Tuple2<double, int> value(double x, {int k = 0}) {
    final t = findSegment(X, x, k: k);
    return Tuple2(fn(k, t.item1), k);
  }

  Tuple2<double, int> derivative(double x, {int k = 0}) {
    final t = findSegment(X, x, k: k);
    return Tuple2(df1(k, t.item1), k);
  }

  Tuple2<double, int> derivative2(double x, {int k = 0}) {
    return Tuple2(0.0, k);
  }

  Tuple2<double, int> derivative3(double x, {int k = 0}) {
    return Tuple2(0.0, k);
  }

  List<double> values(List<double> xs) {
    final int m = xs.length;
    final vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      final t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = fn(k, t.item1);
    }
    return vs;
  }

  List<double> derivatives(List<double> xs) {
    final int m = xs.length;
    final vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      final t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = df1(k, t.item1);
    }
    return vs;
  }

  List<double> derivatives2(List<double> xs) {
    return List<double>.filled(xs.length, 0.0);
  }

  List<double> derivatives3(List<double> xs) {
    return List<double>.filled(xs.length, 0.0);
  }

  void outputFormula(StringSink out) {
    out.writeln('# linear spline: s(t) = a + b*t;  t = x - x0');
    out.writeln('# a,  b,  [x0, x1)');
    int m = N - 1;
    for (int i = 0; i < m; i++) {
      out.writeln('${Y[i]}, ${C[i]}, [${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  void outputDerivative(StringSink out) {
    out.writeln('# step function: s(t) = b;  t = x - x0');
    out.writeln('# b,  [x0, x1)');
    int m = N - 1;
    for (int i = 0; i < m; i++) {
      out.writeln('${C[i]}, [${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  double fn(int k, double t) {
    return C[k] * t + Y[k];
  }

  double df1(int k, double t) {
    return C[k];
  }
}
