import '../spline/Spline.dart';
import '../spline/Cubic.dart';
import '../spline/Quintic.dart';
import '../spline/CosSeries.dart';
import '../spline/SinSeries.dart';
import 'utils.dart';

class Fitting {
  late List<double> xs;
  List<double> ys;
  List<double> y0d0;
  List<double> yNdN;
  List<int> controlIndices;

  late List<double> imf;
  late List<double> trend;
  late Spline gCurve;

  Fitting(this.xs, this.ys, this.y0d0, this.yNdN, this.controlIndices);

  void fitCurve(SplineType splineType) {
    var gs = getIntegral(ys, xs);
    final n = controlIndices.length;
    var xc = List<double>.filled(n, 0.0);
    var gc = List<double>.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      xc[i] = xs[controlIndices[i]];
      gc[i] = gs[controlIndices[i]];
    }
    switch (splineType) {
      case SplineType.cubicSpline:
        if (y0d0.length > 0)
          gCurve = Cubic(xc, gc, val0: y0d0[0], valN: yNdN[0]);
        else
          gCurve = Cubic(xc, gc);
        break;
      case SplineType.quinticSpline:
        gCurve = Quintic(xc, gc, v0: y0d0, vn: yNdN);
        break;
      case SplineType.cosSeries:
        gCurve = CosSeries(xc, gc);
        break;
      case SplineType.sinSeries:
        gCurve = SinSeries(xc, gc);
        break;
    }
    trend = gCurve.derivatives(xs);
    for (int i = 0; i < xs.length; i++) {
      imf[i] = ys[i] - trend[i];
    }
  }
}