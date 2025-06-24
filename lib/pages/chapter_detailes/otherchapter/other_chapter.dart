import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class ChapterSelector extends StatefulWidget {
  const ChapterSelector({Key? key}) : super(key: key);

  @override
  State<ChapterSelector> createState() => _ChapterSelectorState();
}

class _ChapterSelectorState extends State<ChapterSelector> {
  List<Map<String, dynamic>> allChapters = [];
  List<String> zoneNames = [];
  String? selectedZone;

  List<String> chapterNamesInZone = [];
  String? selectedChapter;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchChapters();
  }

  Future<void> fetchChapters() async {
    final response = await PublicRoutesApiService.fetchChapterList();

    if (response.isSuccess && response.data != null) {
      final List chapters = response.data;

      allChapters = List<Map<String, dynamic>>.from(chapters);

      final Set<String> zonesSet = {
        for (var c in chapters)
          if (c['zoneId'] != null) c['zoneId']['zoneName'].toString()
      };

      setState(() {
        zoneNames = zonesSet.toList();
        selectedZone = null;
        selectedChapter = null;
        chapterNamesInZone = [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load chapters: ${response.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SizedBox(height: 2.h),

              // Zone Dropdown
              _dropdownField("Select Zone", zoneNames, selectedZone, (val) {
                setState(() {
                  selectedZone = val;

                  // Filter chapters by selected zone
                  chapterNamesInZone = allChapters
                      .where((c) => c['zoneId']?['zoneName'] == val)
                      .map<String>((c) => c['chapterName'].toString())
                      .toList();

                  selectedChapter = chapterNamesInZone.isNotEmpty
                      ? chapterNamesInZone[0]
                      : null;
                });
              }),

              SizedBox(height: 2.h),

              // Chapter Dropdown (only visible when zone is selected)
              if (selectedZone != null && chapterNamesInZone.isNotEmpty)
                _dropdownField(
                    "Select Chapter", chapterNamesInZone, selectedChapter,
                    (val) {
                  setState(() => selectedChapter = val);
                }),

              SizedBox(height: 4.h),

              // Submit Button
              GestureDetector(
                onTap: () {
                  if (selectedZone != null && selectedChapter != null) {
                    context.push('/Otherschapter');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Please select both zone and chapter.")),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 5.5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Tcolors.red_button,
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

  Widget _dropdownField(String hint, List<String> items, String? selectedValue,
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
