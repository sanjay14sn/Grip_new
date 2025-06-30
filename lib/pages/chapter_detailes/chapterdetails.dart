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
  MemberModel? _cidMember;

  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchAllMemberDetails();
    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);
    final cidId = chapterProvider.chapterDetails?.cidId;
    if (cidId != null && cidId.isNotEmpty) {
      _fetchCidDetails(cidId); // 👈 pass the actual cidId
    }

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
    debugPrint("🔄 Fetching all member details...");
    setState(() {
      _isLoading = true;
      debugPrint("🔃 isLoading set to true");
    });

    _detailedMembers.clear();
    debugPrint("🧹 Cleared existing detailed members");

    const storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');
    debugPrint("🔐 Retrieved user data string: $userDataString");

    String? currentUserId;
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      currentUserId = userData['id'];
      debugPrint("👤 Current user ID: $currentUserId");
    } else {
      debugPrint("⚠️ No user data found in secure storage");
    }

    final chapterProvider =
        Provider.of<ChapterProvider>(context, listen: false);

    // ✅ Get and print the CID ID from ChapterDetails
    final cidId = chapterProvider.chapterDetails?.cidId;
    debugPrint("📛 CID ID from chapter: $cidId");

    final members = chapterProvider.members;
    debugPrint("📋 Total members fetched: ${members.length}");

    for (final member in members) {
      debugPrint("➡️ Processing member ID: ${member.id}");

      if (member.id == currentUserId) {
        debugPrint("🙅 Skipping current user: $currentUserId");
        continue;
      }

      debugPrint("🌐 Fetching details for member: ${member.id}");
      final response =
          await PublicRoutesApiService.fetchMemberDetailsById(member.id);

      if (response.isSuccess && response.data != null) {
        debugPrint("✅ Successfully fetched details for member: ${member.id}");
        final detailed = DetailedMember.fromJson(response.data);
        _detailedMembers.add(detailed);
      } else {
        debugPrint(
            "❌ Failed to fetch details for member: ${member.id}, Status: ${response.isSuccess}");
      }
    }

    setState(() {
      _filteredMembers = _detailedMembers;
      _isLoading = false;
      debugPrint("✅ Member details updated and isLoading set to false");
    });
  }

  Future<void> _fetchCidDetails(String cidId) async {
    debugPrint('🔄 Fetching CID details for ID: $cidId');

    try {
      // Optional: You can set a loading flag here if needed
      // setState(() => _isCidLoading = true);

      final response = await PublicRoutesApiService.fetchCidDetails(
          cidId); // ✅ No 'cid/' prefix

      debugPrint(
          '📥 CID API response: ${response.isSuccess}, data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final data = response.data;

        final member = MemberModel(
          id: data['_id'] ?? '', // ✅ Extract the ID from the root object
          name: data['username'] ?? '',
          company: data['companyName'] ?? '',
          phone: data['mobileNumber'] ?? '',
          role: data['role']?['name'] ?? '',
          website: data['website'], // or null if not provided
          chapterName: data['chapterName'], // or null if not provided
          businessDescription: data['businessDescription'], // or null
          email: data['email'] ?? '',
          address: data['address'], // or null if not provided
        );

        setState(() {
          _cidMember = member;
          // _isCidLoading = false;
        });

        debugPrint('✅ CID details fetched: ${member.name}, ${member.company}');
      } else {
        debugPrint(
            '❌ Failed to fetch CID details. Message: ${response.message}');
        // setState(() => _isCidLoading = false);
      }
    } catch (e) {
      debugPrint('❌ Error fetching CID details: $e');
      // setState(() => _isCidLoading = false);
    }
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
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer Search Box
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 6.h,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              // Shimmer CID Member Section Title
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 73.w,
                  height: 3.3.h,
                  margin: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),

              // Shimmer CID Member Card
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 18.h,
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Shimmer All Members Section Title
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 73.w,
                  height: 3.3.h,
                  margin: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),

              // Shimmer Member Grid
              GridView.builder(
                itemCount: 9,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
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
              ),
            ],
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
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            hintText: "Search by name or company",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(fontSize: 15.7.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // CID Member Section
              if (_cidMember != null) ...[
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
                    "CID MEMBER",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                MemberCard(member: _cidMember!),
                SizedBox(height: 2.h),
              ],

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
                    id: detailed
                        .id, // ✅ Add this line to provide the required ID
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
