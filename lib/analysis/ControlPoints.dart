import 'utils.dart';

class ControlPoints {
  late List<double> xs;
  late List<double> ys;
  late List<double> gs;
  late List<int> indices;
  late List<double> xE;
  late List<double> yE;
  late List<double> gE;
  late bool unitStep;
  late bool needIntegral;

  ControlPoints(this.xs, this.ys,
      {this.needIntegral = true, this.unitStep = true});

  int findExtrema(List<double> hs) {
    indices = [];
    xE = [];
    yE = [];
    int inc = -1;
    int dec = -1;
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
        if (dec != -1) {
          if (i - 1 > dec) {
            int m = (dec + i - 1) ~/ 2;
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
}
