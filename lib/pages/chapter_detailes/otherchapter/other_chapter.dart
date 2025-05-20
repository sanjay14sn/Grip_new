import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/pages/chapter_detailes/mychapter/member_card.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class ChapterSelector extends StatefulWidget {
  const ChapterSelector({Key? key}) : super(key: key);

  @override
  State<ChapterSelector> createState() => _ChapterSelectorState();
}

class _ChapterSelectorState extends State<ChapterSelector> {
  String selectedRegion = "Chennai";
  String selectedChapter = "Grip Madhuram";

  final List<String> regions = ["Chennai", "Coimbatore"];
  final List<String> chapters = [
    "Grip Aram",
    "Grip Virutcham",
    "Grip Madhuram",
    "Grip Kireedam",
    "Grip Amudham"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        _dropdownField("Select Region", regions, selectedRegion, (val) {
          setState(() => selectedRegion = val!);
        }),
        SizedBox(height: 2.h),
        _dropdownField("Chapter Name", chapters, selectedChapter, (val) {
          setState(() => selectedChapter = val!);
        }),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
           context.push('/Otherschapter');
          },
          child: Container(
            width: double.infinity,
            height: 5.5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: Tcolors.red_button, // ✅ Use gradient instead of color
            ),
            child: Center(
              child: Text(
                "Submit",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _dropdownField(String hint, List<String> items, String selectedValue,
      void Function(String?)? onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
