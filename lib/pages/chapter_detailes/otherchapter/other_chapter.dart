import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class ChapterSelector extends StatefulWidget {
  const ChapterSelector({Key? key}) : super(key: key);

  @override
  State<ChapterSelector> createState() => _ChapterSelectorState();
}

class _ChapterSelectorState extends State<ChapterSelector> {
  final _storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> allChapters = [];
  List<String> zoneNames = [];
  String? selectedZone;
  String? userChapterId;
  String? userZoneName;

  List<String> chapterNamesInZone = [];
  String? selectedChapter;      // display string: "Zone - Chapter"
  String? selectedChapterId;    // actual chapter ID for API

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserChapterIdAndFetchChapters();
  }

  Future<void> _loadUserChapterIdAndFetchChapters() async {
    final userDataJson = await _storage.read(key: 'user_data');
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      userChapterId = userData['chapterId'];
      userZoneName = userData['zoneId']?['zoneName'];
    }

    await fetchChapters();
  }

  Future<void> fetchChapters() async {
    final response = await PublicRoutesApiService.fetchChapterList();

    if (response.isSuccess && response.data != null) {
      final List chapters = response.data;

      allChapters = List<Map<String, dynamic>>.from(
        chapters.where((c) => c['_id'] != userChapterId),
      );

      final Set<String> zonesSet = {
        for (var c in allChapters)
          if (c['zoneId'] != null) c['zoneId']['zoneName'].toString()
      };

      if (userZoneName != null) zonesSet.add(userZoneName!);

      setState(() {
        zoneNames = zonesSet.toList();
        selectedZone = null;
        selectedChapter = null;
        chapterNamesInZone = [];
        selectedChapterId = null;
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
              _dropdownField("Select Zone", zoneNames, selectedZone, (val) {
                setState(() {
                  selectedZone = val;

                  final chaptersInZone = allChapters.where((c) =>
                      c['zoneId']?['zoneName'] == val &&
                      c['_id'] != userChapterId).toList();

                  chapterNamesInZone = chaptersInZone
                      .map<String>((c) =>
                          "${c['zoneId']?['zoneName']} - ${c['chapterName']}")
                      .toList();

                  if (chaptersInZone.isNotEmpty) {
                    selectedChapter =
                        "${chaptersInZone[0]['zoneId']['zoneName']} - ${chaptersInZone[0]['chapterName']}";
                    selectedChapterId = chaptersInZone[0]['_id'];
                  } else {
                    selectedChapter = null;
                    selectedChapterId = null;
                  }
                });
              }),
              SizedBox(height: 2.h),
              if (selectedZone != null && chapterNamesInZone.isNotEmpty)
                _dropdownField("Select Chapter", chapterNamesInZone, selectedChapter,
                    (val) {
                  setState(() {
                    selectedChapter = val;
                    final matchedChapter = allChapters.firstWhere(
                        (c) =>
                            "${c['zoneId']['zoneName']} - ${c['chapterName']}" ==
                            val,
                        orElse: () => {});
                    selectedChapterId = matchedChapter['_id'];
                  });
                }),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () async {
                  print('Submit tapped');
                  if (selectedZone != null &&
                      selectedChapter != null &&
                      selectedChapterId != null) {
                    print('Zone: $selectedZone');
                    print('Selected Chapter: $selectedChapter');
                    print('Chapter ID: $selectedChapterId');

                    final response =
                        await PublicRoutesApiService.fetchChapterDetailsById(
                            selectedChapterId!);

                    print('API Success: ${response.isSuccess}');
                    print('API Message: ${response.message}');

                    if (response.isSuccess && response.data != null) {
                      final chapter = ChapterDetail.fromJson(response.data);
                      print('Navigating to Otherschapter with: ${chapter.chapterName}');
                      context.push('/Otherschapter', extra: chapter);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(response.message ??
                                'Failed to load chapter')),
                      );
                    }
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
