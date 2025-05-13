import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/components/Tab_button.dart';
import 'package:grip/pages/chapter_detailes/member_card.dart';
import 'package:grip/pages/chapter_detailes/other_chapter.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class MyChapterPage extends StatefulWidget {
  const MyChapterPage({Key? key}) : super(key: key);

  @override
  State<MyChapterPage> createState() => _MyChapterPageState();
}

class _MyChapterPageState extends State<MyChapterPage> {
  bool showMyChapter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(8), // outer border radius
                        color: Colors
                            .grey.shade300, // background for unselected tabs
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => showMyChapter = true),
                              child: TabButton(
                                title: "MY CHAPTER",
                                isSelected: showMyChapter,
                                leftRadius: true,
                                rightRadius: false,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => showMyChapter = false),
                              child: TabButton(
                                title: "OTHER CHAPTERS",
                                isSelected: !showMyChapter,
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
              showMyChapter ? _buildMyChapterView() : const ChapterSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyChapterView() {
    final List<Map<String, dynamic>> sections = [
      {
        "title": "HEAD TABLE MEMBERS",
        "members": headMembers,
      },
      {
        "title": "CORE COMMITTEE MEMBERS",
        "members": coreCommitteeMembers,
      },
      {
        "title": "ALL MEMBERS",
        "members": allMembers,
      },
    ];

    return Column(
      children: [
        _searchBar(),
        SizedBox(height: 2.h),
        ListView.builder(
          itemCount: sections.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final section = sections[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: section["title"]),
                MemberGrid(members: section["members"]),
                SizedBox(height: 2.h),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Tcolors.title_color,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MemberModel> get headMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "PRESIDENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "VICE PRESIDENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "TREASURER"),
      ];

  List<MemberModel> get coreCommitteeMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN REFERRAL"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN ONE TO ONE"),
        MemberModel("R. Dinesh", "Marvel Interiors", "CHAIRMAN VISITORS",
            isHighlighted: true),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN ATTENDANCE"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN EVENT"),
        MemberModel("S.Kiran", "Krishna Electrical", "CHAIRMAN BUSINESS",
            isHighlighted: true),
        MemberModel("S.Kiran", "Krishna Electrical", "PUBLIC IMAGE",
            isHighlighted: true),
      ];

  List<MemberModel> get allMembers => [
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9845225616"),
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9343526910"),
        MemberModel("S.Kiran", "Krishna Electrical", "", phone: "9652435616"),
      ];
}

class MemberModel {
  final String name;
  final String company;
  final String role;
  final String? phone;
  final bool isHighlighted;

  MemberModel(this.name, this.company, this.role,
      {this.phone, this.isHighlighted = false});
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 73.w,
      height: 3.3.h,
      decoration: BoxDecoration(
        color: Color(0xFF66B0CB),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MemberGrid extends StatelessWidget {
  final List<MemberModel> members;
  const MemberGrid({required this.members});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: members.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 1.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Adjust the number of columns as needed
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.85, // Adjust the aspect ratio as needed
      ),
      itemBuilder: (context, index) {
        return MemberCard(member: members[index]);
      },
    );
  }
}
