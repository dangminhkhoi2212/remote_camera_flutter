import 'package:flutter/material.dart';

class IndexBar with ChangeNotifier {
  int _index = 1;

  int get indexBar => _index;

  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
