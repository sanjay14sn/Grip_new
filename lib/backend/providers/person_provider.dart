import 'package:flutter/material.dart';

class PersonProvider extends ChangeNotifier {
  List<String> _personList = [];
  List<String> get personList => _personList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPersonList() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call with delay
    await Future.delayed(Duration(seconds: 2));

    // Replace this with actual API response
    _personList = [
      "Akash Kumar.P",
      "Akshya.R",
      "Arun.K",
      "Balu.M",
      "Santhosh.A"
    ];

    _isLoading = false;
    notifyListeners();
  }
}
