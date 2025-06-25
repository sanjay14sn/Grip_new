import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/mychapter/member_card.dart';
import 'package:grip/pages/chapter_detailes/mychapter/member_info.dart';
import 'package:grip/pages/chapter_detailes/otherchapter/others_card.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class OtherChapterPage extends StatefulWidget {
  final String chapterId;

  const OtherChapterPage({super.key, required this.chapterId});

  @override
  State<OtherChapterPage> createState() => _OtherChapterPageState();
}

class _OtherChapterPageState extends State<OtherChapterPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<othersMemberModel> allMembers = [];
  List<othersMemberModel> filteredMembers = [];

  bool isMenuOpen = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMembers() async {
    print('🔄 Fetching members for chapter ID: ${widget.chapterId}');

    final response =
        await PublicRoutesApiService.fetchMembersByChapter(widget.chapterId);

    print('📥 API Response Status: ${response.statusCode}');
    print('✅ Success: ${response.isSuccess}');
    print('📦 Raw Data: ${response.data}');

    if (response.isSuccess && response.data != null) {
      try {
        final List<othersMemberModel> members = (response.data as List)
            .map((e) => othersMemberModel.fromJson(e))
            .toList();
        setState(() {
          allMembers = members;
          filteredMembers = members;
          isLoading = false;
        });
      } catch (e) {
        print('❌ Error while parsing member list: $e');
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing member list: $e')),
        );
      }
    } else {
      print('❌ API call failed or no data');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to load members')),
      );
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMembers = allMembers.where((member) {
        final name = member.name.toLowerCase();
        final company = member.company.toLowerCase();
        return name.contains(query) || company.contains(query);
      }).toList();
    });
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Tcolors.title_color),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search by name or company",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberGrid() {
    return GridView.builder(
      itemCount: filteredMembers.length,
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
        return othersMemberCard(member: filteredMembers[index]);
      },
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
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
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
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const Positioned(
                top: -8,
                right: -4,
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: Icon(Icons.add, size: 14, color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E2E7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Text(
                        "Other Chapter Members",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Tcolors.title_color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Search
                  _buildSearchBar(),
                  SizedBox(height: 2.h),

                  // Members
                  Text(
                    "ALL MEMBERS",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildMemberGrid(),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          if (isMenuOpen)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 30),
                    child: _menuItem(Icons.group, "Referrals", () {
                      context.push('/addreferalpage');
                    }),
                  ),
                  _menuItem(Icons.handshake, "Thank U Notes", () {
                    context.push('/thankyounote');
                  }),
                  _menuItem(Icons.chat, "Testimonials", () {
                    context.push('/addtestimonials');
                  }),
                  Transform.translate(
                    offset: const Offset(0, 30),
                    child: _menuItem(Icons.group_work, "One-To-Ones", () {
                      context.push('/onetoone');
                    }),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width * 0.5 - 35,
            child: GestureDetector(
              onTap: () {
                setState(() => isMenuOpen = !isMenuOpen);
                if (isMenuOpen) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
              },
              child: _circleIcon(isMenuOpen ? Icons.close : Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
