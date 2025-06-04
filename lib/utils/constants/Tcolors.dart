import 'package:flutter/cupertino.dart';

class Tcolors {
  Tcolors._();
  //gradient Colors

  static const Gradient red_gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    // 339.87° is approximately top-left to bottom-right
    colors: [
      Color(0xFFC02221), // Hex color
      Color.fromRGBO(241, 22, 21, 0.92), // RGBA with opacity
    ],
    stops: [0.3505, 0.667], // Matching the 35.05% and 66.7%
  );
  static const Gradient red_button = LinearGradient(
    colors: [
      Color(0xFFFF3534), // Soft red
      Color(0xFF575757), // Muted gray
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient bottomnav = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFD6E0E1), // Light Gray
    ],
    stops: [0.0, 1.0], // Full gradient range
  );

  //appbar
  static const Color bottombar = Color(0xFF50A6C5);
  static const Color cardcolor = Color(0xFFF3F4F9);
  static const Color cardcolor2 = Color(0xD9D9D91A);
  static const Color head_title_color = Color(0xFF262121);
  static const Color sub_title_color = Color(0xFF000000);
  static const Color title_color = Color(0xFFC83837);
  static const Color divider = Color(0xFFC7C2C280);
  static const Color homecard = Color(0xFFE3F2F5);
  static const Color smalll_button = Color(0xFFDC2A29);
}
