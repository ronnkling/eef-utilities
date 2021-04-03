import 'package:flutter/foundation.dart';
import '../spline/Spline.dart';

class FittingModel extends ChangeNotifier {
  SplineType _splineType = SplineType.quinticSpline;
  int _splitLevels = 5; // splitting levels

  bool _showData = true;
  bool _showCtrolPoints = false;
  bool _showCurve = true;
  bool _showDiff = true;

  SplineType get splineType => _splineType;
  set splineType(SplineType value) {
    _splineType = value;
    notifyListeners();
  }

  int get splitLevels => _splitLevels;
  set splitLevels(int value) {
    _splitLevels = value;
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

  bool get showCurve => _showCurve;
  set showCurve(bool value) {
    _showCurve = value;
    notifyListeners();
  }

  bool get showDiff => _showDiff;
  set showDiff(bool value) {
    _showDiff = value;
    notifyListeners();
  }

  void setDefaults() {
    _splineType = SplineType.quinticSpline;
    _splitLevels = 5;
    _showData = true;
    _showCtrolPoints = false;
    _showCurve = true;
    _showDiff = true;
    notifyListeners();
  }
}
