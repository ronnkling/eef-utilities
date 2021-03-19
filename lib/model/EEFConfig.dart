import 'package:flutter/foundation.dart';

enum SplineFn { cubicSpline, quinticSplice, cosSeries, sinSeries }

class EEFConfig extends ChangeNotifier {
  // scale up or scale down
  bool scaleUp = true;
  SplineFn splineFn = SplineFn.quinticSplice;
  // max number of components
  int components = 15;
  // display the control points
  bool showCntrlPoints = false;
  // display the contiguous component
  bool showContiguous = false;
  // scale up, control point on difference of
  // inflection points segment or extrama
  bool upInflexion = true;
  // adjust end ponts
  bool adjustEnds = true;
  // scale up, display segments of inflexion points
  bool upShowSegment = false;
  // scale down, partition on curvature
  // or change rate
  bool downCurvature = false;
}
