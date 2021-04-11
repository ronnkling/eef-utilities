import 'utils.dart';

class Partition {
  List<double> xs;
  List<double> ys;
  int splitLevels; // splitting levels
  List<List<int>> indicesList = []; // partition indices at different level

  late List<double> _ws; // weights
  late List<double> _ms; // moments

  Partition(this.xs, this.ys, this.splitLevels);

  // levels of bi-partition, use curvature (deriv 2) or change rate (deriv 1)
  int prepare({bool curv = true}) {
    if (curv)
      _ws = getAbs(getDeriv2(ys, xs));
    else
      _ws = getAbs(getDeriv(ys, xs));
    _ms = List<double>.from(_ws);
    for (int i = 0; i < xs.length; i++) {
      _ms[i] *= xs[i];
    }
    _ws = getIntegral(_ws, xs);
    _ms = getIntegral(_ms, xs);
    int m = xs.length - 1;
    double t;
    for (int split = 1; split <= splitLevels; split++) {
      int k = (1 << split) + 1; // 2^split + 1
      final pts = List<int>.filled(k, 0);
      if (indicesList.length == 0) {
        if (_ws[m] == 0)
          t = (xs[m] - xs[0]) / 2; // 0 weight, half way
        else
          t = _ms[m] / _ws[m]; // weight center
        pts[1] = _findIndex(t, 0, m + 1);
        pts[2] = m;
      } else {
        final prev = indicesList[indicesList.length - 1];
        int n = prev.length - 1;
        int j = 1;
        for (int i = 0; i < n; i++) {
          double dw = _ws[prev[i + 1]] - _ws[prev[i]];
          if (dw == 0)
            t = (xs[prev[i + 1]] - xs[prev[i]]) / 2; // 0 weight, half way
          else
            t = (_ms[prev[i + 1]] - _ms[prev[i]]) / dw; // weight center
          pts[j++] = _findIndex(t, prev[i], prev[i + 1]);
          pts[j++] = prev[i + 1];
        }
      }
      List<int> pts2 = [];
      // remove duplicates
      int n = pts.length;
      pts2.add(pts[0]);
      for (int i = 1; i < n; i++) {
        if (pts[i] > pts[i - 1]) pts2.add(pts[i]);
      }
      indicesList.add(pts2);
    }
    return indicesList.length;
  }

  int _findIndex(double t, int k1, int k2) {
    int k = k1;
    for (int i = k1; i < k2; ++i) {
      if (xs[i] <= t && t < xs[i + 1]) {
        k = i;
        break;
      }
    }
    return k;
  }
}
