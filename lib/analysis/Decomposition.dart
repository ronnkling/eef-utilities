import '../spline/Spline.dart';
import '../spline/Linear.dart';
import '../spline/Cubic.dart';
import '../spline/Quintic.dart';
import '../spline/CosSeries.dart';
import '../spline/SinSeries.dart';
import 'ControlPoints.dart';
import 'utils.dart';

class Decomposition {
  late List<double> xs;
  List<double> ys;
  List<double> y0d0;
  bool inflexion;
  bool unitStep;
  bool adjustEnds;
  late int extrema;
  late List<double> imf;
  late List<double> trend;
  late ControlPoints ctrlPoints;
  late Spline gCurve;
  late List<int> inflexIndex;

  Decomposition(this.xs, this.ys, this.y0d0)
      : inflexion = true,
        unitStep = false,
        adjustEnds = true;

  Decomposition.ysOnly(this.ys, this.y0d0)
      : inflexion = true,
        unitStep = false,
        adjustEnds = true {
    int n = ys.length;
    xs = List.filled(n, 0.0);
    for (int i = 0; i < n; i++) xs[i] = i.toDouble();
  }

  void separate(SplineFn splineFn) {
    ctrlPoints = ControlPoints(xs, ys);
    ctrlPoints.unitStep = unitStep;
    imf = initIMF(ys);
    extrema = ctrlPoints.findExtrema(imf);
    if (extrema < 3) {
      average();
    } else {
      switch (splineFn) {
        case SplineFn.cubicSpline:
          if (y0d0.length > 0)
            gCurve = Cubic(ctrlPoints.xE, ctrlPoints.gE, val0: y0d0[0]);
          else
            gCurve = Cubic(ctrlPoints.xE, ctrlPoints.gE);
          break;
        case SplineFn.quinticSpline:
          if (adjustEnds) {
            ctrlPoints.qAdjustASide();
            ctrlPoints.qAdjustZSide();
          }
          if (y0d0.length > 0)
            gCurve = Quintic(ctrlPoints.xE, ctrlPoints.gE, v0: y0d0, vn: [0.0]);
          else
            gCurve =
                Quintic(ctrlPoints.xE, ctrlPoints.gE, v0: [0.0], vn: [0.0]);
          break;
        case SplineFn.cosSeries:
          gCurve = CosSeries(ctrlPoints.xE, ctrlPoints.gE);
          break;
        case SplineFn.sinSeries:
          gCurve = SinSeries(ctrlPoints.xE, ctrlPoints.gE);
          break;
      }
      trend = gCurve.derivatives(xs);
      for (int i = 0; i < xs.length; i++) {
        imf[i] = ys[i] - trend[i];
      }
    }
  }

  void setYs(List<double> yy) {
    ys = yy;
    trend.clear();
    imf.clear();
    inflexIndex.clear();
  }

  List<double> initIMF(List<double> yy) {
    inflexIndex.clear();
    if (!inflexion) return yy;
    List<double> hs;
    if (unitStep)
      hs = getDiffValues(yy);
    else
      hs = getDiff(yy, xs);
    var cp = ControlPoints(xs, yy);
    cp.findExtrema(hs);
    inflexIndex = cp.indices;
    int m = cp.yE.length - 1;
    // extend the first point
    cp.yE[0] = cp.yE[1];
    // extenf the last point
    cp.yE[m] = cp.yE[m - 1];
    var segments = Linear(cp.xE, cp.yE);
    List<double> initTrend = segments.values(xs);
    int n = xs.length;
    for (int i = 0; i < n; i++) hs[i] = yy[i] - initTrend[i];
    return hs;
  }

  void average() {
    int n = ys.length;
    double avg = 0.0;
    for (int i = 1; i < n; ++i)
      avg += 0.5 * (ys[i - 1] + ys[i]) * (xs[i] - xs[i - 1]);
    avg /= (xs[n - 1] - xs[0]);
    trend = List.filled(n, avg);
    imf = List.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      imf[i] = ys[i] - trend[i];
    }
  }
}
