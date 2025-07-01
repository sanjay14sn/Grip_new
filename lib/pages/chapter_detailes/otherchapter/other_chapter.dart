import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:shimmer/shimmer.dart';
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

  Future<void> fetchZones({int maxRetries = 3}) async {
    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;
      debugPrint('🌍 Attempt $attempt to fetch zones');

      final response = await PublicRoutesApiService.fetchZoneList();

      if (response.isSuccess && response.data != null) {
        setState(() {
          zones = response.data;
          isLoading = false;
        });
        success = true;
        debugPrint('✅ Zones fetched successfully');
      } else {
        debugPrint(
            '❌ Failed attempt $attempt to fetch zones: ${response.message}');
        if (attempt == maxRetries) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to load zones: ${response.message}")),
          );
        }
      }
    }
  }

  Future<void> fetchChaptersByZone(String zoneId, {int maxRetries = 3}) async {
    setState(() {
      chaptersInZone = [];
      selectedChapterId = null;
    });

    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;
      debugPrint('🏘️ Attempt $attempt to fetch chapters for zone: $zoneId');

      final response = await PublicRoutesApiService.fetchChaptersByZone(zoneId);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> filteredChapters =
            response.data.where((c) => c['_id'] != userChapterId).toList();
        setState(() {
          chaptersInZone = filteredChapters;
        });
        success = true;
        debugPrint('✅ Chapters fetched successfully');
      } else {
        debugPrint(
            '❌ Failed attempt $attempt to fetch chapters: ${response.message}');
        if (attempt == maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to load chapters: ${response.message}")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildShimmerLoading()
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
                  final selected =
                      zones.firstWhere((z) => z['zoneName'] == val);
                  selectedZoneId = selected['_id'];
                  fetchChaptersByZone(selectedZoneId!);
                },
              ),
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
                          (c) => c['_id'] == selectedChapterId,
                          orElse: () => null,
                        )?['chapterName'],
                  (val) {
                    final matched = chaptersInZone.firstWhere(
                      (c) => c['chapterName'] == val,
                      orElse: () => null,
                    );
                    if (matched != null) {
                      selectedChapterId = matched['_id'];
                    }
                  },
                ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  if (selectedZoneId != null && selectedChapterId != null) {
                    final chapterName = chaptersInZone.firstWhere(
                        (c) => c['_id'] == selectedChapterId)['chapterName'];
                    context.push(
                        '/Otherschapter/$selectedChapterId?name=$chapterName');
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
              ),
            ],
          );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          _shimmerBox(width: double.infinity, height: 50),
          SizedBox(height: 2.h),
          _shimmerBox(width: double.infinity, height: 50),
          SizedBox(height: 4.h),
          _shimmerBox(width: double.infinity, height: 48),
        ],
      ),
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
          fillColor: Colors.white,
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
