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

  List<dynamic> zones = [];
  List<dynamic> chaptersInZone = [];
  String? selectedZoneId;
  String? selectedChapterId;
  String? userChapterId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndFetchZones();
  }

  Future<void> _loadUserDataAndFetchZones() async {
    final userDataJson = await _storage.read(key: 'user_data');
    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      userChapterId = userData['chapterId'];
    }
    await fetchZones();
  }

  Future<void> fetchZones() async {
    final response = await PublicRoutesApiService.fetchZoneList();
    if (response.isSuccess && response.data != null) {
      setState(() {
        zones = response.data;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load zones: ${response.message}")),
      );
    }
  }

  Future<void> fetchChaptersByZone(String zoneId) async {
    setState(() {
      chaptersInZone = [];
      selectedChapterId = null;
    });

    final response = await PublicRoutesApiService.fetchChaptersByZone(zoneId);
    if (response.isSuccess && response.data != null) {
      final List<dynamic> filteredChapters =
          response.data.where((c) => c['_id'] != userChapterId).toList();
      setState(() {
        chaptersInZone = filteredChapters;
      });
    } else {
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
              _dropdownField(
                  "Select Zone",
                  zones.map((z) => z['zoneName'].toString()).toList(),
                  selectedZoneId == null
                      ? null
                      : zones.firstWhere(
                          (z) => z['_id'] == selectedZoneId)['zoneName'],
                  (val) {
                final selected = zones.firstWhere((z) => z['zoneName'] == val);
                selectedZoneId = selected['_id'];
                fetchChaptersByZone(selectedZoneId!);
              }),
              SizedBox(height: 2.h),
              if (selectedZoneId != null && chaptersInZone.isNotEmpty)
                _dropdownField(
                  "Select Chapter",
                  chaptersInZone
                      .map((c) => c['chapterName'].toString())
                      .toList(),
                  selectedChapterId == null
                      ? null
                      : chaptersInZone.firstWhere(
                          (c) => c['_id'] == selectedChapterId)['chapterName'],
                  (val) {
                    final matched = chaptersInZone
                        .firstWhere((c) => c['chapterName'] == val);
                    selectedChapterId = matched['_id'];
                  },
                ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  if (selectedZoneId != null && selectedChapterId != null) {
                    context.push('/Otherschapter/$selectedChapterId');
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
