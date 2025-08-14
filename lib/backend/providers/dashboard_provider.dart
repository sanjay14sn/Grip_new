import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';

class DashboardProvider extends ChangeNotifier {
  Map<String, dynamic> dashboardData = {
    'referralGiven': 0,
    'referralReceived': 0,
    'thankyouGiven': 0,
    'thankyouReceived': 0,
    'testimonialGiven': 0,
    'testimonialReceived': 0,
    'onetoones': 0,
    'visitors': 0,
    'revenueGiven': 0,
    'revenueReceived': 0,
    'training': 0,
  };

  int selectedIndex = 0;

  final Map<int, String> filterMap = {
    0: '3-months',
    1: '6-months',
    2: '12-months',
    3: '', // Life time
  };

  Future<void> fetchDashboardData([int? filterIndex]) async {
    if (filterIndex != null) selectedIndex = filterIndex;

    final filterType = filterMap[selectedIndex]!;

    final response = await PublicRoutesApiService.fetchDashboardCount(
        filterType: filterType);

    if (response.isSuccess && response.data != null) {
      final raw = response.data;
      dashboardData = {
        'referralGiven': raw['referralGivenCount'] ?? 0,
        'referralReceived': raw['referralReceivedCount'] ?? 0,
        'thankyouGiven': raw['thankYouGivenCount'] ?? 0,
        'thankyouReceived': raw['thankYouReceivedCount'] ?? 0,
        'testimonialGiven': raw['testimonialGivenCount'] ?? 0,
        'testimonialReceived': raw['testimonialReceivedCount'] ?? 0,
        'onetoones': raw['oneToOneCount'] ?? 0,
        'visitors': raw['visitorCount'] ?? 0,
        'revenueGiven': raw['thankYouGivenAmount'] ?? 0,
        'revenueReceived': raw['thankYouReceivedAmount'] ?? 0,
        'training': raw['trainingCount'] ?? 0,
      };
      notifyListeners();
    }
  }

  void setFilter(int index) {
    selectedIndex = index;
    fetchDashboardData();
    notifyListeners();
  }
}
