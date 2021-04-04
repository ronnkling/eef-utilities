import 'package:eefapp/analysis/Partition.dart';
import 'package:flutter/foundation.dart';
import '../spline/Spline.dart';
import '../analysis/Fitting.dart';

class FittingModel extends ChangeNotifier {
  SplineType _splineType = SplineType.quinticSpline;
  int _splitLevels = 5; // splitting levels
  late final List<double> xs;
  late List<double> ys;
  late List<double> y0d0;
  late List<double> yNdN;
  bool _showData = true;
  bool _showCtrolPoints = false;
  bool _showCurve = true;
  bool _showDiff = true;
  bool _useCurvature = true;
  late List<Fitting> fittingList;

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

  bool get useCurvature => _useCurvature;
  set useCurvature(bool value) {
    _useCurvature = value;
    notifyListeners();
  }

  void setDefaults() {
    _splineType = SplineType.quinticSpline;
    _splitLevels = 5;
    _showData = true;
    _showCtrolPoints = false;
    _showCurve = true;
    _showDiff = true;
    _useCurvature = true;
    notifyListeners();
  }

  void fitCurves() async {
    fittingList = await compute(buildDecompList, this);
    notifyListeners();
  }
}

List<Fitting> buildDecompList(FittingModel model) {
  final part = Partition(model.xs, model.ys, model.splitLevels);
  part.prepare(curv: model.useCurvature);
  final indicesList = part.indicesList;
  final fittingList = List<Fitting>.empty();
  for (var indices in indicesList) {
    final fitting =
        Fitting(model.xs, model.ys, model.y0d0, model.yNdN, indices);
    fitting.fitCurve(model.splineType);
    fittingList.add(fitting);
    model.ys = fitting.curve;
  }
  return fittingList;
}
