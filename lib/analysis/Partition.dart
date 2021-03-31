import 'utils.dart';

class Partition {
  List<double> xs;
  List<double> ys;
  int nControlPoints; // number of control points
  late List<List<int>> parts; // partition indices at different level

  late List<double> _ws; // weights
  late List<double> _ms; // moments

  Partition(this.xs, this.ys, this.nControlPoints);

  // levels of bi-partition, use curvature (deriv 2) or change rate (deriv 1)
  int prepare(int levels, {bool curv = true}) {
    parts = List<List<int>>.empty();
    if (curv)
      _ws = getAbs(getDiff2(ys, xs));
    else
      _ws = getAbs(getDiff(ys, xs));
    _ms = _ws;
    for (int i = 0; i < xs.length; i++) {
      _ms[i] *= xs[i];
    }
    _ws = getIntegral(_ws, xs);
    _ms = getIntegral(_ms, xs);
    int m = xs.length - 1;
    int k = 0;
    double t;
    do {
      k = (1 << (parts.length + 1)) + 1;
      var r = List<int>.filled(k, 0);
      if (parts.length == 0) {
        if (_ws[m] == 0)
          t = (xs[m] - xs[0]) / 2; // 0 weight, half way
        else
          t = _ms[m] / _ws[m]; // weight center
        r[1] = _findIndex(t, 0, m + 1);
        r[2] = m;
      } else {
        var rp = parts[parts.length - 1];
        m = rp.length - 1;
        int j = 1;
        for (int i = 0; i < m; ++i) {
          double dw = _ws[rp[i + 1]] - _ws[rp[i]];
          if (dw == 0)
            t = (xs[rp[i + 1]] - xs[rp[i]]) / 2; // 0 weight, half way
          else
            t = (_ms[rp[i + 1]] - _ms[rp[i]]) / dw; // weight center
          r[j++] = _findIndex(t, rp[i], rp[i + 1]);
          r[j++] = rp[i + 1];
        }
      }
      var r2 = List<int>.empty();
      // remove duplicates
      int n = r.length;
      r2.add(r[0]);
      for (int i = 1; i < n; i++) {
        if (r[i] > r[i - 1]) r2.add(r[i]);
      }
      parts.add(r2);
    } while (k < nControlPoints && parts.length <= levels);
    return parts.length;
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
