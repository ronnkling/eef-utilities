import 'package:flutter/foundation.dart';

enum SplineFn { cubicSpline, quinticSplice, cosSeries, sinSeries }

class EEFConfig extends ChangeNotifier {
  // scale up or scale down
  bool scaleUp = true;
  SplineFn? splineFn = SplineFn.quinticSplice;
  // max number of components
  int maxComponents = 5;
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

  void setScaleUp(bool v) {
    scaleUp = v;
    notifyListeners();
  }

  void setShowCntrlPoints(bool v) {
    showCntrlPoints = v;
    notifyListeners();
  }

  void setShowContiguous(bool v) {
    showContiguous = v;
    notifyListeners();
  }

  void setUpInflexion(bool v) {
    upInflexion = v;
    notifyListeners();
  }

  void setAdjustEnds(bool v) {
    adjustEnds = v;
    notifyListeners();
  }

  void setUpShowSegment(bool v) {
    upShowSegment = v;
    notifyListeners();
  }

  void setDownCurvature(bool v) {
    downCurvature = v;
    notifyListeners();
  }

  void setSplineFn(SplineFn? v) {
    splineFn = v;
    notifyListeners();
  }

  void setMaxComponents(int k) {
    maxComponents = k;
    notifyListeners();
  }

  void setDefaults() {
    scaleUp = true;
    splineFn = SplineFn.quinticSplice;
    maxComponents = 5;
    showCntrlPoints = false;
    showContiguous = false;
    upInflexion = true;
    adjustEnds = true;
    upShowSegment = false;
    downCurvature = false;
    notifyListeners();
  }
}
