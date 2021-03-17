import 'package:flutter/foundation.dart';

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void inc() {
    _count++;
    notifyListeners();
  }
}
