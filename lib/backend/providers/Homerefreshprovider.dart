import 'package:flutter/material.dart';

class HomeRefreshNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  bool get shouldRefresh => _shouldRefresh;

  void trigger() {
    _shouldRefresh = true;
    notifyListeners();
  }

  void reset() {
    _shouldRefresh = false;
  }
}
