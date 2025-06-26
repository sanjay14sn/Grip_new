import 'package:flutter/foundation.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners(); // 👈 Manual trigger
}
