import 'package:flutter/material.dart';

class TabBarNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  void updateIndex(int num) {
    _currentIndex = num;
    notifyListeners();
  }
}
