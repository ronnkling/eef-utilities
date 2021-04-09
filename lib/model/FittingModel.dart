import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../spline/Spline.dart';
import '../analysis/Partition.dart';
import '../analysis/Fitting.dart';

class FittingModel extends ChangeNotifier {
  SplineType _splineType = SplineType.quinticSpline;
  int _splitLevels = 5; // splitting levels
  int _currentLevel = 1;
  late List<double> xs;
  late List<double> ys;
  List<double> y0d0 = [];
  List<double> yNdN = [];
  bool _showData = true;
  bool _showControlPoints = false;
  bool _showCurve = true;
  bool _showDiff = true;
  bool _useCurvature = true;
  List<Fitting> fittingList = [];

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

  int get currentLevel => _currentLevel;
  set currentLevel(int value) {
    _currentLevel = value;
    notifyListeners();
  }

  bool get showData => _showData;
  set showData(bool value) {
    _showData = value;
    notifyListeners();
  }

  bool get showControlPoints => _showControlPoints;
  set showControlPoints(bool value) {
    _showControlPoints = value;
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

  bool get useCurvature => _useCurvature;
  set useCurvature(bool value) {
    _useCurvature = value;
    notifyListeners();
  }

  void setDefaults() {
    _splineType = SplineType.quinticSpline;
    _splitLevels = 5;
    _currentLevel = 1;
    _showData = true;
    _showControlPoints = false;
    _showCurve = true;
    _showDiff = true;
    _useCurvature = true;
    notifyListeners();
  }

  void fitCurves() async {
    fittingList = await compute(
        _buildFittingList,
        Tuple7<List<double>, List<double>, int, bool, List<double>,
                List<double>, SplineType>(
            xs, ys, splitLevels, useCurvature, y0d0, yNdN, splineType));
    notifyListeners();
  }
}

List<Fitting> _buildFittingList(
    Tuple7<List<double>, List<double>, int, bool, List<double>, List<double>,
            SplineType>
        model) {
  final part = Partition(model.item1, model.item2, model.item3);
  part.prepare(curv: model.item4);
  final indicesList = part.indicesList;
  List<Fitting> fittingList = [];
  for (var indices in indicesList) {
    final fitting =
        Fitting(model.item1, model.item2, model.item5, model.item6, indices);
    fitting.fitCurve(model.item7);
    fittingList.add(fitting);
  }
  return fittingList;
}
