import 'package:flutter/foundation.dart';
import '../spline/Spline.dart';

class EEFConfig extends ChangeNotifier {
  // scale up or scale down
  bool scaleUp = true;
  SplineType? splineType = SplineType.quinticSpline;
  // max number of components
  int maxComponents = 5;
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

  void setSplineType(SplineType? v) {
    splineType = v;
    notifyListeners();
  }

  void setMaxComponents(int k) {
    maxComponents = k;
    notifyListeners();
  }

  void setDefaults() {
    scaleUp = true;
    splineType = SplineType.quinticSpline;
    maxComponents = 5;
    showContiguous = false;
    upInflexion = true;
    adjustEnds = true;
    upShowSegment = false;
    downCurvature = false;
    notifyListeners();
  }
}
