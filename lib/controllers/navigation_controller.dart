import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  int get selectedIndex => _selectedIndex;
  int get previousIndex => _previousIndex;

  void updateIndex(int index) {
    _previousIndex = _selectedIndex;
    _selectedIndex = index;
    notifyListeners();
  }
}
