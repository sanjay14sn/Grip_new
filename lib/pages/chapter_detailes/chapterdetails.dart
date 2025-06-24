import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:grip/components/Tab_button.dart';
import 'package:grip/pages/chapter_detailes/detailedmember.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/dummy.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllMemberDetails();
  }

  Future<void> _fetchAllMemberDetails() async {
    setState(() => _isLoading = true);
    _detailedMembers.clear();

    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    for (var member in chapterProvider.members) {
      final response =
          await PublicRoutesApiService.fetchMemberDetailsById(member.id);
      if (response.isSuccess && response.data != null) {
        final detailed = DetailedMember.fromJson(response.data);
        _detailedMembers.add(detailed);
      } else {
        debugPrint('❌ Failed for memberId ${member.id}: ${response.message}');
      }
    }

    setState(() => _isLoading = false);
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

              // Content
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
    return _isLoading
        ? GridView.builder(
            itemCount: 9, // show 9 shimmer cards while loading
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
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Tcolors.title_color),
                    SizedBox(width: 2.w),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
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
                itemCount: _detailedMembers.length,
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
                  final detailed = _detailedMembers[index];

                  // Convert to MemberModel
                  final memberModel = MemberModel(
                    name: detailed.name,
                    company: detailed.company,
                    phone: detailed.mobile,
                    role: '', // or pass actual role
                  );

                  return MemberCard(member: memberModel);
                },
              ),
              SizedBox(height: 2.h),
            ],
          );
  }
}
