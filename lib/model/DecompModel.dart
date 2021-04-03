import 'package:flutter/foundation.dart';
import '../spline/Spline.dart';

class DecompModel extends ChangeNotifier {
  SplineType _splineType = SplineType.quinticSpline;
  int _maxComponents = 5; // max number of components
  bool _useInflexion = true; // use inflection points or extrama
  bool _adjustEnds = true; // adjust end points

  bool _showData = true;
  bool _showCtrolPoints = false;
  bool _showTrend = true;
  bool _showIMF = true;

  SplineType get splineType => _splineType;
  set splineType(SplineType value) {
    _splineType = value;
    notifyListeners();
  }

  int get maxComponents => _maxComponents;
  set maxComponents(int value) {
    _maxComponents = value;
    notifyListeners();
  }

  bool get useInflexion => _useInflexion;
  set useInflexion(bool value) {
    _useInflexion = value;
    notifyListeners();
  }

  bool get adjustEnds => _adjustEnds;
  set adjustEnds(bool value) {
    _adjustEnds = value;
    notifyListeners();
  }

  bool get showData => _showData;
  set showData(bool value) {
    _showData = value;
    notifyListeners();
  }

  bool get showCtrolPoints => _showCtrolPoints;
  set showCtrolPoints(bool value) {
    _showCtrolPoints = value;
    notifyListeners();
  }

  bool get showTrend => _showTrend;
  set showTrend(bool value) {
    _showTrend = value;
    notifyListeners();
  }

  bool get showIMF => _showIMF;
  set showIMF(bool value) {
    _showIMF = value;
    notifyListeners();
  }

  void setDefaults() {
    _splineType = SplineType.quinticSpline;
    _maxComponents = 5;
    _useInflexion = true;
    _adjustEnds = true;
    _showData = true;
    _showCtrolPoints = false;
    _showTrend = true;
    _showIMF = true;
    notifyListeners();
  }
}
