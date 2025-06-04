import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/dummy.dart';
import 'package:grip/pages/chapter_detailes/otherchapter/others_card.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class OtherChapterPage extends StatefulWidget {
  const OtherChapterPage({Key? key}) : super(key: key);

  @override
  State<OtherChapterPage> createState() => _MyChapterPageState();
}

class _MyChapterPageState extends State<OtherChapterPage> {
  bool isMenuOpen = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E2E7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Center(
                        child: Text(
                          "Grip Madhuram",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Tcolors.title_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildMyChapterView(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          if (isMenuOpen)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Transform.translate(
                      offset: Offset(0, 30),
                      child: _menuItem(Icons.group, "Referrals", () {
                        print("Referrals tapped");
                         context.push('/addreferalpage');
                        // Add your navigation or logic here
                      }),
                    ),
                    _menuItem(Icons.handshake, "Thank U Notes", () {
                      print("Thank U Notes tapped");
                           context.push('/thankyounote');
                    }),
                    _menuItem(Icons.chat, "Testimonials", () {
                       context.push('/addtestimonials');
                      print("Testimonials tapped");
                    }),
                    Transform.translate(
                      offset: Offset(0, 30),
                      child: _menuItem(Icons.group_work, "One-To-Ones", () {
                        print("One-To-Ones tapped");
                         context.push('/onetoone');
                      }),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Buttons (Home + Add/Close)
          if (!isMenuOpen)
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: 212,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // translucent white
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x405A5A5A), // 25% opacity shadow
                          offset: Offset(0, 1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.3), // subtle glassy border
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle home button tap
                          },
                          child: _circleIcon(Icons.home),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMenuOpen = !isMenuOpen;
                            });

                            if (!isMenuOpen) return;

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            });
                          },
                          child: _circleIcon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (isMenuOpen)
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.5 -
                  35, // center based on icon size
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isMenuOpen = !isMenuOpen;
                  });
                },
                child: _circleIcon(Icons.close),
              ),
            ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.red),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              Positioned(
                top: -8,
                right: -4,
                child: Container(
                  height: 16,
                  width: 16,
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMyChapterView() {
    final List<Map<String, dynamic>> sections = [
      {"title": "HEAD TABLE MEMBERS", "members": headMembers},
      {"title": "CORE COMMITTEE MEMBERS", "members": coreCommitteeMembers},
      {"title": "ALL MEMBERS", "members": allMembers},
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
          Icon(Icons.search, color: Tcolors.title_color),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              decoration:
                  InputDecoration(hintText: "Search", border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
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
        color: const Color(0xFF2C2B2B), // Rich dark gray
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
        return othersMemberCard(member: members[index]);
      },
    );
  }
}
