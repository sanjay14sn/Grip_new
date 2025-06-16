import 'package:flutter/services.dart';

Future<void> lockOrientationToPortrait() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
