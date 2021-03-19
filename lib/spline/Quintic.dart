import 'package:tuple/tuple.dart';
import 'Spline.dart';

class Quintic implements Spline {
  late int N;
  late int k0;
  late int kn;

  late List<double> X;
  late List<double> Y;
  late List<double> B;
  late List<double> C;
  late List<double> D;
  late List<double> E;
  late List<double> F;

  Quintic(List<double> xs, List<double> ys, List<double> v0, List<double> vn) {
    k0 = v0.length;
    kn = vn.length;
    N = k0 + xs.length + kn;
    X = List.filled(N, 0.0);
    Y = List.filled(N, 0.0);
    B = List.filled(N, 0.0);
    C = List.filled(N, 0.0);
    D = List.filled(N, 0.0);
    E = List.filled(N, 0.0);
    F = List.filled(N, 0.0);
    int k = 0;
    X[k] = xs[0];
    Y[k] = ys[0];
    k++;
    for (int i = 0; i < k0; ++i) {
      X[k] = xs[0];
      Y[k] = v0[i];
      k++;
    }
    for (int i = 1; i < xs.length; i++) {
      X[k] = xs[i];
      Y[k] = ys[i];
      k++;
    }
    for (int i = 0; i < kn; i++) {
      X[k] = xs[xs.length - 1];
      Y[k] = vn[i];
      k++;
    }
    _initialize();
  }

  Tuple2<double, int> value(double x, {int k = 0}) {
    var t = findSegment(X, x, k: k);
    return Tuple2(fn(k, t.item1), k);
  }

  Tuple2<double, int> derivative(double x, {int k = 0}) {
    var t = findSegment(X, x, k: k);
    return Tuple2(df1(k, t.item1), k);
  }

  Tuple2<double, int> derivative2(double x, {int k = 0}) {
    var t = findSegment(X, x, k: k);
    return Tuple2(df2(k, t.item1), k);
  }

  Tuple2<double, int> derivative3(double x, {int k = 0}) {
    var t = findSegment(X, x, k: k);
    return Tuple2(df3(k, t.item1), k);
  }

  List<double> values(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      var t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = fn(k, t.item1);
    }
    return vs;
  }

  List<double> derivatives(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      var t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = df1(k, t.item1);
    }
    return vs;
  }

  List<double> derivatives2(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      var t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = df2(k, t.item1);
    }
    return vs;
  }

  List<double> derivatives3(List<double> xs) {
    int m = xs.length;
    var vs = List<double>.filled(m, 0.0);
    int k = 0;
    for (int i = 0; i < m; i++) {
      var t = findSegment(X, xs[i], k: k);
      k = t.item2;
      vs[i] = df3(k, t.item1);
    }
    return vs;
  }

  void outputFormula(StringSink out) {
    out.writeln(
        '# quintic spline: s(t) = a + b*t + c*t^2 + d*t^3 + e*t^4 + f*t^5;  t = x - x0');
    out.writeln('# a,  b,  c,  d,  e,  f,  [x0, x1)');
    int m = N - kn - 1;
    for (int i = 0; i < m; i++) {
      out.writeln(
          '${Y[i]}, ${B[i]}, ${C[i]}, ${D[i]}, ${E[i]}, ${F[i]}, [${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  void outputDerivative(StringSink out) {
    out.writeln(
        '# quartic spline: s(t) = a + b*t + c*t^2 + d*t^3 + e*t^4;  t = x - x0');
    out.writeln('# a,  b,  c,  d,  e,  [x0, x1)');
    int m = N - kn - 1;
    for (int i = 0; i < m; i++) {
      out.writeln(
          '${B[i]}, ${2.0 * C[i]}, ${3.0 * D[i]}, ${4.0 * D[i]},${5.0 * D[i]},[${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  void _initialize() {
    //     algorithm 600, collected algorithms from acm.
    //     algorithm appeared in acm-trans. math. software, vol.9, no. 2,
    //     jun., 1983, p. 258-259.
    //
    //     TSpline5 computes the coefficients of a quintic natural quintic spli
    //     s(x) with knots x(i) interpolating there to given function values:
    //               s(x(i)) = y(i)  for i = 1,2, ..., n.
    //     in each interval (x(i),x(i+1)) the spline function s(xx) is a
    //     polynomial of fifth degree:
    //     s(xx) = ((((f(i)*p+e(i))*p+d(i))*p+c(i))*p+b(i))*p+y(i)    (*)
    //           = ((((-f(i)*q+e(i+1))*q-d(i+1))*q+c(i+1))*q-b(i+1))*q+y(i+1)
    //     where  p = xx - x(i)  and  q = x(i+1) - xx.
    //     (note the first subscript in the second expression.)
    //     the different polynomials are pieced together so that s(x) and
    //     its derivatives up to s"" are continuous.
    //
    //        input:
    //
    //     n          number of data points, (at least three, i.e. n > 2)
    //     x(1:n)     the strictly increasing or decreasing sequence of
    //                knots.  the spacing must be such that the fifth power
    //                of x(i+1) - x(i) can be formed without overflow or
    //                underflow of exponents.
    //     y(1:n)     the prescribed function values at the knots.
    //
    //        output:
    //
    //     b,c,d,e,f  the computed spline coefficients as in (*).
    //         (1:n)  specifically
    //                b(i) = s'(x(i)), c(i) = s"(x(i))/2, d(i) = s"'(x(i))/6,
    //                e(i) = s""(x(i))/24,  f(i) = s""'(x(i))/120.
    //                f(n) is neither used nor altered.  the five arrays
    //                b,c,d,e,f must always be distinct.
    //
    //        option:
    //
    //     it is possible to specify values for the first and second
    //     derivatives of the spline function at arbitrarily many knots.
    //     this is done by relaxing the requirement that the sequence of
    //     knots be strictly increasing or decreasing.  specifically:
    //
    //     if x(j) = x(j+1) then s(x(j)) = y(j) and s'(x(j)) = y(j+1),
    //     if x(j) = x(j+1) = x(j+2) then in addition s"(x(j)) = y(j+2).
    //
    //     note that s""(x) is discontinuous at a double knot and, in
    //     addition, s"'(x) is discontinuous at a triple knot.  the
    //     subroutine assigns y(i) to y(i+1) in these cases and also to
    //     y(i+2) at a triple knot.  the representation (*) remains
    //     valid in each open interval (x(i),x(i+1)).  at a double knot,
    //     x(j) = x(j+1), the output coefficients have the following values:
    //       y(j) = s(x(j))          = y(j+1)
    //       b(j) = s'(x(j))         = b(j+1)
    //       c(j) = s"(x(j))/2       = c(j+1)
    //       d(j) = s"'(x(j))/6      = d(j+1)
    //       e(j) = s""(x(j)-0)/24     e(j+1) = s""(x(j)+0)/24
    //       f(j) = s""'(x(j)-0)/120   f(j+1) = s""'(x(j)+0)/120
    //     at a triple knot, x(j) = x(j+1) = x(j+2), the output
    //     coefficients have the following values:
    //       y(j) = s(x(j))         = y(j+1)    = y(j+2)
    //       b(j) = s'(x(j))        = b(j+1)    = b(j+2)
    //       c(j) = s"(x(j))/2      = c(j+1)    = c(j+2)
    //       d(j) = s"'((x(j)-0)/6    d(j+1) = 0  d(j+2) = s"'(x(j)+0)/6
    //       e(j) = s""(x(j)-0)/24    e(j+1) = 0  e(j+2) = s""(x(j)+0)/24
    //       f(j) = s""'(x(j)-0)/120  f(j+1) = 0  f(j+2) = s""'(x(j)+0)/120
    if (N <= 2) return;
    int i, m;
    double pqqr, p, q, r, s, t, u, v, b1, p2, p3, q2, q3, r2, pq, pr, qr;
    //     coefficients of a positive definite, pentadiagonal matrix,
    //     stored in D, E, F from 1 to n-3.
    m = N - 2;
    q = X[1] - X[0];
    r = X[2] - X[1];
    q2 = q * q;
    r2 = r * r;
    qr = q + r;
    D[0] = E[0] = 0.0;
    if (q != 0.0)
      D[1] = q * 6.0 * q2 / (qr * qr);
    else
      D[1] = 0.0;

    if (m > 1) {
      for (i = 1; i < m; ++i) {
        p = q;
        q = r;
        r = X[i + 2] - X[i + 1];
        p2 = q2;
        q2 = r2;
        r2 = r * r;
        pq = qr;
        qr = q + r;
        if (q != 0.0) {
          q3 = q2 * q;
          pr = p * r;
          pqqr = pq * qr;
          D[i + 1] = q3 * 6.0 / (qr * qr);
          D[i] += (q + q) *
              (pr * 15.0 * pr +
                  (p + r) * q * (pr * 20.0 + q2 * 7.0) +
                  q2 * ((p2 + r2) * 8.0 + pr * 21.0 + q2 + q2)) /
              (pqqr * pqqr);
          D[i - 1] += q3 * 6.0 / (pq * pq);
          E[i] = q2 * (p * qr + pq * 3.0 * (qr + r + r)) / (pqqr * qr);
          E[i - 1] += q2 * (r * pq + qr * 3.0 * (pq + p + p)) / (pqqr * pq);
          F[i - 1] = q3 / pqqr;
        } else
          D[i + 1] = E[i] = F[i - 1] = 0;
      }
    }
    if (r != 0.0) D[m - 1] += r * 6.0 * r2 / (qr * qr);
    //     First and second order divided differences of the given function
    //     values, stored in b from 2 to n and in c from 3 to n
    //     respectively. care is taken of double and triple knots.
    for (i = 1; i < N; ++i) {
      if (X[i] != X[i - 1]) {
        B[i] = (Y[i] - Y[i - 1]) / (X[i] - X[i - 1]);
      } else {
        B[i] = Y[i];
        Y[i] = Y[i - 1];
      }
    }
    for (i = 2; i < N; ++i) {
      if (X[i] != X[i - 2]) {
        C[i] = (B[i] - B[i - 1]) / (X[i] - X[i - 2]);
      } else {
        C[i] = B[i] * 0.5;
        B[i] = B[i - 1];
      }
    }
    //     Solve the linear system with c(i+2) - c(i+1) as right-hand side. */
    if (m > 1) {
      p = C[0] = E[m - 1] = F[0] = F[m - 2] = F[m - 1] = 0;
      C[1] = C[3] - C[2];
      D[1] = 1.0 / D[1];

      if (m > 2) {
        for (i = 2; i < m; ++i) {
          q = D[i - 1] * E[i - 1];
          D[i] = 1.0 / (D[i] - p * F[i - 2] - q * E[i - 1]);
          E[i] -= q * F[i - 1];
          C[i] = C[i + 2] - C[i + 1] - p * C[i - 2] - q * C[i - 1];
          p = D[i - 1] * F[i - 1];
        }
      }
    }
    C[N - 2] = C[N - 1] = 0.0;
    if (N > 3) {
      for (i = N - 3; i > 0; --i)
        C[i] = (C[i] - E[i] * C[i + 1] - F[i] * C[i + 2]) * D[i];
    }
    //     Integrate the third derivative of s(x)
    m = N - 1;
    q = X[1] - X[0];
    r = X[2] - X[1];
    b1 = B[1];
    q3 = q * q * q;
    qr = q + r;
    if (qr != 0.0) {
      v = C[1] / qr;
      t = v;
    } else
      v = t = 0.0;
    if (q != 0.0)
      F[0] = v / q;
    else
      F[0] = 0.0;
    for (i = 1; i < m; ++i) {
      p = q;
      q = r;
      if (i != m - 1)
        r = X[i + 2] - X[i + 1];
      else
        r = 0.0;
      p3 = q3;
      q3 = q * q * q;
      pq = qr;
      qr = q + r;
      s = t;
      if (qr != 0.0)
        t = (C[i + 1] - C[i]) / qr;
      else
        t = 0.0;
      u = v;
      v = t - s;
      if (pq != 0.0) {
        F[i] = F[i - 1];
        if (q != 0.0) F[i] = v / q;
        E[i] = s * 5.0;
        D[i] = (C[i] - q * s) * 10;
        C[i] = D[i] * (p - q) +
            (B[i + 1] - B[i] + (u - E[i]) * p3 - (v + E[i]) * q3) / pq;
        B[i] = (p * (B[i + 1] - v * q3) + q * (B[i] - u * p3)) / pq -
            p * q * (D[i] + E[i] * (q - p));
      } else {
        C[i] = C[i - 1];
        D[i] = E[i] = F[i] = 0.0;
      }
    }
    //     End points x(1) and x(n)
    p = X[1] - X[0];
    s = F[0] * p * p * p;
    E[0] = D[0] = 0.0;
    C[0] = C[1] - s * 10;
    B[0] = b1 - (C[0] + s) * p;

    q = X[N - 1] - X[N - 2];
    t = F[N - 2] * q * q * q;
    E[N - 1] = D[N - 1] = 0;
    C[N - 1] = C[N - 2] + t * 10;
    B[N - 1] += (C[N - 1] - t) * q;
  }

  double fn(int i, double t) {
    return ((((F[i] * t + E[i]) * t + D[i]) * t + C[i]) * t + B[i]) * t + Y[i];
  }

  double df1(int i, double t) {
    return (((5.0 * F[i] * t + 4.0 * E[i]) * t + 3.0 * D[i]) * t + 2.0 * C[i]) *
            t +
        B[i];
  }

  double df2(int i, double t) {
    return ((20.0 * F[i] * t + 12.0 * E[i]) * t + 6.0 * D[i]) * t + 2.0 * C[i];
  }

  double df3(int i, double t) {
    return (60.0 * F[i] * t + 24.0 * E[i]) * t + 6.0 * D[i];
  }
}
