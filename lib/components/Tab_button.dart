import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/utils/constants/Tcolors.dart';

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool leftRadius;
  final bool rightRadius;

  const TabButton({
    required this.title,
    required this.isSelected,
    this.leftRadius = false,
    this.rightRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ?Tcolors.title_color : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: leftRadius ? Radius.circular(8) : Radius.zero,
          right: rightRadius ? Radius.circular(8) : Radius.zero,
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}