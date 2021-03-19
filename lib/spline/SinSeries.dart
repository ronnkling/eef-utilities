// @dart=2.9
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:scidart/numdart.dart';
import 'Spline.dart';

class SinSeies implements Spline {
  int N;
  double H;
  List<double> X;
  List<double> Y;
  List<double> C;

  SinSeies(this.X, this.Y) {
    N = X.length;
    H = pi / (X[N - 1] - X[0]);
    C = List.filled(N, 0.0);
    _initialize();
  }

  Tuple2<double, int> value(double x, {int k = 0}) {
    return Tuple2(fn(x), k);
  }

  Tuple2<double, int> derivative(double x, {int k = 0}) {
    return Tuple2(df1(x), k);
  }

  Tuple2<double, int> derivative2(double x, {int k = 0}) {
    return Tuple2(df2(x), k);
  }

  Tuple2<double, int> derivative3(double x, {int k = 0}) {
    return Tuple2(df3(x), k);
  }

  List<double> values(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    for (int i = 0; i < m; i++) {
      vs[i] = fn(xs[i]);
    }
    return vs;
  }

  List<double> derivatives(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    for (int i = 0; i < m; i++) {
      vs[i] = df1(xs[i]);
    }
    return vs;
  }

  List<double> derivatives2(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    for (int i = 0; i < m; i++) {
      vs[i] = df2(xs[i]);
    }
    return vs;
  }

  List<double> derivatives3(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    for (int i = 0; i < m; i++) {
      vs[i] = df3(xs[i]);
    }
    return vs;
  }

  void outputFormula(StringSink out) {
    out.writeln('# sin series: s(t) = c0 + c1*sin(h*t) + ... + cn*sin(n*h*t)');
    out.writeln('# c0, c1, c2, ... cn');
    for (int i = 0; i < N; i++) {
      out.write('${C[i]},');
      if (i % 10 == 0 || i == N - 1) out.writeln();
    }
    out.writeln('# L = ${X[N - 1] - X[0]}, H = $H, total lines = $N');
  }

  void outputDerivative(StringSink out) {
    out.writeln('# cos series: s(t) = c1*cos(h*t) + ... + cn*cos(n*h*t)');
    out.writeln('# c1, c2, ... cn');
    for (int i = 1; i < N; i++) {
      out.write('${i * H * C[i]},');
      if ((i - 1) % 10 == 0 || i == N - 1) out.writeln();
    }
    out.writeln('# L = ${X[N - 1] - X[0]}, H = $H, total lines = $N');
  }

  void _initialize() {
    var a = Array2d.fixed(N, N);
    for (int i = 0; i < N; i++) {
      double t = X[i] - X[0];
      a[i][0] = 1.0;
      for (int j = 1; j < N; j++) {
        a[i][j] = sin(j * H * t);
      }
    }
    var b = Array2d.fromVector(Array(Y), N);
    var x = matrixSolve(a, b);
    for (int i = 0; i < N; i++) C[i] = x[i][0];
  }

  double fn(double x) {
    double v = C[0];
    double t = x - X[0];
    for (int i = 1; i < N; i++) v += C[i] * sin(i * H * t);
    return v;
  }

  double df1(double x) {
    double v = 0.0;
    double t = x - X[0];
    for (int i = 1; i < N; i++) {
      v += i * C[i] * H * cos(i * H * t);
    }
    return v;
  }

  double df2(double x) {
    double v = 0.0;
    double t = x - X[0];
    for (int i = 1; i < N; i++) {
      double h = i * H;
      double h2 = h * h;
      v -= C[i] * h2 * sin(h * t);
    }
    return v;
  }

  double df3(double x) {
    double v = 0.0;
    double t = x - X[0];
    for (int i = 1; i < N; i++) {
      double h = i * H;
      double h3 = h * h * h;
      v -= C[i] * h3 * cos(h * t);
    }
    return v;
  }
}
