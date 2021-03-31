import 'package:scidart/numdart.dart';
import 'utils.dart';

class ControlPoints {
  List<double> xs;
  List<double> ys;
  bool unitStep; // x change 1 on each step
  bool needIntegral;
  late List<double> gs; // integration of ys
  late List<int> indices; // indices of control points
  late List<double> xE; // x values of control points
  late List<double> yE; // y values of control points
  late List<double> gE; // integration values of control points

  ControlPoints(this.xs, this.ys,
      {this.needIntegral = true, this.unitStep = true});

  // find the extrema for the given hs values
  int findExtrema(List<double> hs) {
    indices = [];
    xE = [];
    yE = [];
    int inc = -1; // -1 for not increment
    int dec = -1; // -1 for not decrement
    indices.add(0);
    xE.add(xs[0]);
    yE.add(ys[0]);
    int n = ys.length - 1;
    for (int i = 1; i < n; i++) {
      double hp = hs[i - 1];
      double hc = hs[i];
      if (hp == hc) {
        continue;
      } else if (hp < hc) {
        // increasing
        if (dec != -1) {
          if (i - 1 > dec) {
            int m = (dec + i - 1) ~/ 2; // half way
            indices.add(m);
            xE.add(xs[m]);
            yE.add(ys[m]);
          } else {
            indices.add(dec);
            xE.add(xs[dec]);
            yE.add(ys[dec]);
          }
        }
        inc = i;
        dec = -1;
      } else if (hp > hc) {
        // decreasing
        if (inc != -1) {
          if (i - 1 > inc) {
            int m = (inc + i - 1) ~/ 2;
            indices.add(m);
            xE.add(xs[m]);
            yE.add(ys[m]);
          } else {
            indices.add(inc);
            xE.add(xs[inc]);
            yE.add(ys[inc]);
          }
        }
        dec = i;
        inc = -1;
      }
    }
    indices.add(n);
    xE.add(xs[n]);
    yE.add(ys[n]);
    if (needIntegral) {
      if (unitStep)
        gs = getIntegralValues(ys);
      else
        gs = getIntegral(ys, xs);
      int m = indices.length;
      for (int i = 0; i < m; ++i) gE.add(gs[indices[i]]);
    }
    return yE.length;
  }

  // only apply to quintic spline
  void qAdjustASide() {
    //        if (xE.length < 5
    //                || xE[1] - xE[0] >= xE[2] - xE[1]
    //                || qAbs(yE[1] - yE[0]) > 0.5 * qAbs(yE[2] - yE[1]))
    //            return;
    //        gE[0] = gE[1] - yE[0] * (xE[1] - xE[0]);

    if (xE.length < 5 || xE[1] - xE[0] >= xE[2] - xE[1]) return;
    double dg =
        _extendIntegral(xE[2], xE[1], xE[0], yE[1], yE[0], gE[0] - gE[1]);
    xE[0] = 2 * xE[1] - xE[2];
    gE[0] = gE[1] + dg;
  }

  // only apply to quintic spline
  void qAdjustZSide() {
    int m = xE.length - 1;
    //        if (xE.length < 5
    //                || xE[m] - xE[m - 1] >= xE[m - 1] - xE[m - 2]
    //                || qAbs(yE[m] - yE[m - 1]) > 0.5 * qAbs(yE[m - 1] - yE[m - 2]))
    //            return;
    //        gE[m] = gE[m - 1] + yE[m] * (xE[m] - xE[m - 1]);

    if (xE.length < 5 || xE[m] - xE[m - 1] >= xE[m - 1] - xE[m - 2]) return;
    double dg = _extendIntegral(
        xE[m - 2], xE[m - 1], xE[m], yE[m - 1], yE[m], gE[m] - gE[m - 1]);
    xE[m] = 2 * xE[m - 1] - xE[m - 2];
    gE[m] = gE[m - 1] + dg;
  }

  // extend the end point to a point with first derivative 0
  // quintic polynome at^5 + bt^4 + ct^3 + et
  static double _extendIntegral(
      double x1, double x2, double x3, double y2, double y3, double g3) {
    double c = x3 - x2;
    double c2 = c * c;
    double c3 = c2 * c;
    double c4 = c3 * c;
    double c5 = c4 * c;

    double d = x2 - x1;
    double d2 = d * d;
    double d3 = d2 * d;
    double d4 = d3 * d;
    double d5 = d4 * d;

    var a = Array2d.fixed(3, 3);
    var b = Array2d.fixed(3, 1);

    a[0][0] = c5;
    a[0][1] = c4;
    a[0][2] = c3;
    b[0][0] = g3 - c * y2;

    a[1][0] = 5 * c4;
    a[1][1] = 4 * c3;
    a[1][2] = 3 * c2;
    b[1][0] = y3 - y2;

    a[2][0] = 20 * d3;
    a[2][1] = 12 * d2;
    a[2][2] = 6 * d;
    b[2][0] = 0.0;

    var x = matrixSolve(a, b);
    double g4 = x[0][0] * d5 + x[1][0] * d4 + x[2][0] * d3 + y2 * d;
    return g4;
  }
}
