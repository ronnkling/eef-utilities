import 'package:tuple/tuple.dart';
import 'Spline.dart';

enum Cond { NOT_A_KNOT, DERIVATIVE_1, DERIVATIVE_2 }

class Cubic implements Spline {
  List<double> X;
  List<double> Y;
  int N;
  late List<double> A;
  late List<double> B;
  late List<double> C;

  Cubic(this.X, this.Y,
      {Cond cond0 = Cond.NOT_A_KNOT,
      double val0 = 0.0,
      Cond condN = Cond.NOT_A_KNOT,
      double valN = 0.0})
      : N = X.length {
    A = List.filled(N, 0.0);
    B = List.filled(N, 0.0);
    C = List.filled(N, 0.0);
    _initialize(cond0, val0, condN, valN);
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
    out.writeln('# cubic spline: s(t) = a + b*t + c*t^2 + d*t^3;  t = x - x0');
    out.writeln('# a,  b,  c,  d,  [x0, x1)');
    int m = N - 1;
    for (int i = 0; i < m; i++) {
      out.writeln('${Y[i]}, ${C[i]}, ${B[i]}, ${A[i]}, [${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  void outputDerivative(StringSink out) {
    out.writeln('# quadratic spline: s(t) = a + b*t + c*t^2;  t = x - x0');
    out.writeln('# a,  b,  c,  [x0, x1)');
    int m = N - 1;
    for (int i = 0; i < m; i++) {
      out.writeln(
          '${C[i]}, ${2.0 * B[i]}, ${3.0 * A[i]}, [${X[i]}, ${X[i + 1]})');
    }
    out.writeln('# total lines = $m');
  }

  void _initialize(Cond cond0, double val0, Cond condN, double valN) {
    //      subroutine cubspl ( tau, c, n, ibcbeg, ibcend )
    //  from  * a practical guide to splines *  by c. de boor
    //     ************************  input  ***************************
    //     n = number of data points. assumed to be .ge. 2.
    //     (tau(i), c(1,i), i=1,...,n) = abscissae and ordinates of the
    //        data points. tau is assumed to be strictly increasing.
    //     ibcbeg, ibcend = boundary condition indicators, and
    //     c(2,1), c(2,n) = boundary condition information. specifically,
    //        cond0 = 0  means no boundary condition at tau(1) is given.
    //           in this case, the not-a-knot condition is used, i.e. the
    //           jump in the third derivative across tau(2) is forced to
    //           zero, thus the first and the second cubic polynomial pieces
    //           are made to coincide.)
    //        cond0 = 1  means that the slope at tau(1) is made to equal
    //           c(2,1), supplied by input.
    //        cond0 = 2  means that the second derivative at tau(1) is
    //           made to equal c(2,1), supplied by input.
    //        condN = 0, 1, or 2 has analogous meaning concerning the
    //           boundary condition at tau(n), with the additional infor-
    //           mation taken from c(2,n).
    //     ***********************  output  **************************
    //     c(j,i), j=1,...,4; i=1,...,l (= n-1) = the polynomial coefficients
    //        of the cubic interpolating spline with interior knots (or
    //        joints) tau(2), ..., tau(n-1). precisely, in the interval
    //        (tau(i), tau(i+1)), the spline f is given by
    //           f(x) = c(1,i)+h*(c(2,i)+h*(c(3,i)+h*c(4,i)/3.)/2.)
    //        where h = x - tau(i). the function program *ppvalu* may be
    //        used to evaluate f or its derivatives from tau,c, l = n-1,
    //        and k=4.
    int i, j, m;
    double divdf1, divdf3, dtau, g = 0.0;
    //***** a tridiagonal linear system for the unknown slopes s(i) of
    //  f  at tau(i), i=1,...,n, is generated and then solved by gauss elim-
    //  ination, with s(i) ending up in c(2,i), all i.
    //     c(3,.) and c(4,.) are used initially for temporary storage.
    int n1 = N - 1;
    // compute first differences of x sequence and store in C also,
    // compute first divided difference of data and store in D.
    for (m = 1; m < N; ++m) {
      B[m] = X[m] - X[m - 1];
      A[m] = (Y[m] - Y[m - 1]) / B[m];
    }
    // construct first equation from the boundary condition, of the form
    //             D[0]*s[0] + C[0]*s[1] = B[0]
    bool skip = false;
    if (cond0 == Cond.NOT_A_KNOT) {
      if (N == 2) {
        //     no condition at left end and n = 2.
        A[0] = 1.0;
        B[0] = 1.0;
        C[0] = 2.0 * A[1];
      } else {
        //     not-a-knot condition at left end and n .gt. 2.
        A[0] = B[2];
        B[0] = B[1] + B[2];
        C[0] = ((B[1] + 2.0 * B[0]) * A[1] * B[2] + B[1] * B[1] * A[2]) / B[0];
      }
    } else if (cond0 == Cond.DERIVATIVE_1) {
      //     slope prescribed at left end.
      C[0] = val0;
      A[0] = 1.0;
      B[0] = 0.0;
    } else if (cond0 == Cond.DERIVATIVE_2) {
      //     second derivative prescribed at left end.
      A[0] = 2.0;
      B[0] = 1.0;
      C[0] = 3.0 * A[1] - B[1] / 2.0 * val0;
    }
    if (N > 2) {
      //  if there are interior knots, generate the corresp. equations and car-
      //  ry out the forward pass of gauss elimination, after which the m-th
      //  equation reads    D[m]*s[m] + C[m]*s[m+1] = B[m].
      for (m = 1; m < n1; ++m) {
        g = -B[m + 1] / A[m - 1];
        C[m] = g * C[m - 1] + 3.0 * (B[m] * A[m + 1] + B[m + 1] * A[m]);
        A[m] = g * B[m - 1] + 2.0 * (B[m] + B[m + 1]);
      }
      // construct last equation from the second boundary condition, of the form
      //           (-g*D[n-2])*s[n-2] + D[n-1]*s[n-1] = B[n-1]
      //     if slope is prescribed at right end, one can go directly to back-
      //     substitution, since c array happens to be set up just right for it
      //     at this point.
      if (condN == Cond.NOT_A_KNOT) {
        if (N > 3 || cond0 != Cond.NOT_A_KNOT) {
          //     not-a-knot and n .ge. 3, and either n.gt.3 or  also not-a-knot at
          //     left end point.
          g = B[N - 2] + B[N - 1];
          C[N - 1] = ((B[N - 1] + 2.0 * g) * A[N - 1] * B[N - 2] +
                  B[N - 1] * B[N - 1] * (Y[N - 2] - Y[N - 3]) / B[N - 2]) /
              g;
          g = -g / A[N - 2];
          A[N - 1] = B[N - 2];
        } else {
          //     either (n=3 and not-a-knot also at left) or (n=2 and not not-a-
          //     knot at left end point).
          C[N - 1] = 2.0 * A[N - 1];
          A[N - 1] = 1.0;
          g = -1.0 / A[N - 2];
        }
      } else if (condN == Cond.DERIVATIVE_1) {
        C[N - 1] = valN;
        skip = true;
      } else if (condN == Cond.DERIVATIVE_2) {
        //     second derivative prescribed at right endpoint.
        C[N - 1] = 3.0 * A[N - 1] + B[N - 1] / 2.0 * valN;
        A[N - 1] = 2.0;
        g = -1.0 / A[N - 2];
      }
    } else {
      if (condN == Cond.NOT_A_KNOT) {
        if (cond0 != Cond.NOT_A_KNOT) {
          //     either (n=3 and not-a-knot also at left) or (n=2 and not not-a-
          //     knot at left end point).
          C[N - 1] = 2.0 * A[N - 1];
          A[N - 1] = 1.0;
          g = -1.0 / A[N - 2];
        } else {
          //     not-a-knot at right endpoint and at left endpoint and n = 2.
          C[N - 1] = A[N - 1];
          skip = true;
        }
      } else if (condN == Cond.DERIVATIVE_1) {
        C[N - 1] = valN;
        skip = true;
      } else if (condN == Cond.DERIVATIVE_2) {
        //     second derivative prescribed at right endpoint.
        C[N - 1] = 3.0 * A[N - 1] + B[N - 1] / 2.0 * valN;
        A[N - 1] = 2.0;
        g = -1.0 / A[N - 2];
      }
    }
    // complete forward pass of gauss elimination.
    if (!skip) {
      A[N - 1] = g * B[N - 2] + A[N - 1];
      C[N - 1] = (g * C[N - 2] + C[N - 1]) / A[N - 1];
    }
    // carry out back substitution
    j = n1 - 1;
    do {
      C[j] = (C[j] - B[j] * C[j + 1]) / A[j];
      --j;
    } while (j >= 0);
    //****** generate cubic coefficients in each interval, i.e., the deriv.s
    //  at its left endpoint, from value and slope at its endpoints.
    for (i = 1; i < N; ++i) {
      dtau = B[i];
      divdf1 = (Y[i] - Y[i - 1]) / dtau;
      divdf3 = C[i - 1] + C[i] - 2.0 * divdf1;
      B[i - 1] = (divdf1 - C[i - 1] - divdf3) / dtau;
      A[i - 1] = (divdf3 / dtau) / dtau;
    }
    // overwrite coefficients the right end points
    j = n1 - 1;
    double h = X[n1] - X[j];
    C[n1] = ((3.0 * A[j]) * h + 2.0 * B[j]) * h + C[j];
    B[n1] = A[j] * h + B[j] / 3.0;
    A[n1] = A[j];
  }

  double fn(int k, double t) {
    return ((A[k] * t + B[k]) * t + C[k]) * t + Y[k];
  }

  double df1(int k, double t) {
    return (3.0 * A[k] * t + 2.0 * B[k]) * t + C[k];
  }

  double df2(int k, double t) {
    return 6.0 * A[k] * t + 2.0 * B[k];
  }

  double df3(int k, double t) {
    return 6.0 * A[k];
  }
}
