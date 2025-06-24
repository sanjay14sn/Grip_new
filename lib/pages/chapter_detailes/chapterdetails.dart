import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:grip/components/Tab_button.dart';
import 'package:grip/pages/chapter_detailes/detailedmember.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/mychapter/member_card.dart';
import 'package:grip/pages/chapter_detailes/otherchapter/other_chapter.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MyChapterPage extends StatefulWidget {
  const MyChapterPage({Key? key}) : super(key: key);

  @override
  State<MyChapterPage> createState() => _MyChapterPageState();
}

class _MyChapterPageState extends State<MyChapterPage> {
  bool isMyChapterSelected = true;

  List<DetailedMember> _detailedMembers = [];
  List<DetailedMember> _filteredMembers = [];

  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllMemberDetails();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _detailedMembers.where((member) {
        final name = member.name.toLowerCase();
        final company = member.company.toLowerCase();
        return name.contains(query) || company.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchAllMemberDetails() async {
    setState(() => _isLoading = true);
    _detailedMembers.clear();

    const storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');

    String? currentUserId;
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      currentUserId = userData['id'];
    }

    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final members = chapterProvider.members;

    for (final member in members) {
      if (member.id == currentUserId) {
        debugPrint("🙅 Skipping current user: $currentUserId");
        continue; // Skip current user
      }

      final response =
          await PublicRoutesApiService.fetchMemberDetailsById(member.id);

      if (response.isSuccess && response.data != null) {
        final detailed = DetailedMember.fromJson(response.data);
        _detailedMembers.add(detailed);
      }
    }

    setState(() {
      _filteredMembers = _detailedMembers;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 2.h),

              // Tab Switch
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isMyChapterSelected = true),
                              child: TabButton(
                                title: "MY CHAPTER",
                                isSelected: isMyChapterSelected,
                                leftRadius: true,
                                rightRadius: false,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isMyChapterSelected = false),
                              child: TabButton(
                                title: "OTHER CHAPTERS",
                                isSelected: !isMyChapterSelected,
                                leftRadius: false,
                                rightRadius: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              isMyChapterSelected
                  ? _buildMyChapterView()
                  : const ChapterSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyChapterView() {
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final memberCount = chapterProvider.members.length;

    return _isLoading
        ? GridView.builder(
            itemCount: memberCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 1.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    Container(
                      width: 8.w,
                      height: 1.5.h,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      width: 10.w,
                      height: 1.3.h,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Tcolors.title_color),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Container(
                        height: 4.h,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _searchController,
                          textAlignVertical:
                              TextAlignVertical.center, // 👈 Center the text
                          decoration: const InputDecoration(
                            hintText: "Search by name or company",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.zero, // 👈 Remove extra padding
                          ),
                          style: TextStyle(fontSize: 15.7.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // Section Header
              Container(
                width: 73.w,
                height: 3.3.h,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2B2B),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  "ALL MEMBERS",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 1.h),

              // Member Grid
              GridView.builder(
                itemCount: _filteredMembers.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 1.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 3.w,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final detailed = _filteredMembers[index];
                  final memberModel = MemberModel(
                    name: detailed.name,
                    company: detailed.company,
                    phone: detailed.mobile,
                    role: null,
                    website: detailed.website,
                    chapterName: detailed.chapterName,
                    businessDescription: detailed.description,
                    email: detailed.email,
                    address: detailed.address,
                  );
                  return MemberCard(member: memberModel);
                },
              ),
              SizedBox(height: 2.h),
            ],
          );
  }
}
