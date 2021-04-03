import 'package:tuple/tuple.dart';

List<double> getDeriv(List<double> vs, List<double> ts) {
  var d1 = List.filled(vs.length, 0.0);
  int n = vs.length - 1;
  d1[0] = (vs[1] - vs[0]) / (ts[1] - ts[0]);
  for (int i = 1; i < n; ++i)
    d1[i] = (vs[i + 1] - vs[i - 1]) / (ts[i + 1] - ts[i - 1]);
  d1[n] = (vs[n] - vs[n - 1]) / (ts[n] - ts[n - 1]);
  return d1;
}

List<double> getDerivValues(List<double> vs) {
  var d1 = List.filled(vs.length, 0.0);
  int n = vs.length - 1;
  d1[0] = vs[1] - vs[0];
  for (int i = 1; i < n; ++i) d1[i] = 0.5 * (vs[i + 1] - vs[i - 1]);
  d1[n] = vs[n] - vs[n - 1];
  return d1;
}

List<double> getDeriv2(List<double> vs, List<double> ts) {
  var d2 = List.filled(vs.length, 0.0);
  int n = vs.length - 1;
  for (int i = 1; i < n; ++i)
    d2[i] = ((vs[i + 1] - vs[i]) / (ts[i + 1] - ts[i]) -
            (vs[i] + vs[i - 1]) / (ts[i] + ts[i - 1])) *
        2.0 /
        (ts[i + 1] - ts[i - 1]);
  d2[0] = d2[1]; // take following value
  d2[n] = d2[n - 1]; // take previous value
  return d2;
}

List<double> getDerif2Values(List<double> vs) {
  var d2 = List.filled(vs.length, 0.0);
  int n = vs.length - 1;
  for (int i = 1; i < n; ++i) d2[i] = vs[i + 1] - 2.0 * vs[i] + vs[i - 1];
  d2[0] = d2[1]; // take following value
  d2[n] = d2[n - 1]; // take previous value
  return d2;
}

List<double> getIntegral(List<double> vs, List<double> ts) {
  int n = vs.length;
  var s = List.filled(n, 0.0);
  for (int i = 1; i < n; ++i)
    s[i] = s[i - 1] + 0.5 * (vs[i - 1] + vs[i]) * (ts[i] - ts[i - 1]);
  return s;
}

List<double> getIntegralValues(List<double> vs) {
  int n = vs.length;
  var s = List.filled(n, 0.0);
  for (int i = 1; i < n; ++i) s[i] = s[i - 1] + 0.5 * (vs[i - 1] + vs[i]);
  return s;
}

List<double> getAbs(List<double> vs) {
  int n = vs.length;
  var s = List.filled(n, 0.0);
  for (int i = 0; i < n; ++i) s[i] = vs[i] >= 0.0 ? vs[i] : -vs[i];
  return s;
}

List<double> multiply(List<double> vs, double factor) {
  List<double> prod = List.from(vs, growable: false);
  if (factor != 1.0) {
    int n = vs.length;
    for (int i = 0; i < n; ++i) prod[i] *= factor;
  }
  return prod;
}

List<double> substract(List<double> v1, List<double> v2) {
  int n = v1.length;
  var d = List.filled(n, 0.0);
  for (int i = 0; i < n; ++i) d[i] = v1[i] - v2[i];
  return d;
}

Tuple2<double, double> minMax(List<double> vs) {
  var vMax = double.negativeInfinity;
  var vMin = double.infinity;
  int n = vs.length;
  double v;
  for (int i = 0; i < n; ++i) {
    v = vs[i];
    if (v > vMax) vMax = v;
    if (v < vMin) vMin = v;
  }
  return Tuple2(vMin, vMax);
}
