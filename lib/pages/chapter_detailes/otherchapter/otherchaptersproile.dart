import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/shimmer.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/otherchapter/others_card.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class OtherChapterPage extends StatefulWidget {
  final String chapterId;
  final String chapterName;

  const OtherChapterPage(
      {super.key, required this.chapterId, required this.chapterName});

  @override
  State<OtherChapterPage> createState() => _OtherChapterPageState();
}

class _OtherChapterPageState extends State<OtherChapterPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<othersMemberModel> allMembers = [];
  List<othersMemberModel> filteredMembers = [];
  othersMemberModel? _cidMember;

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
    const int maxRetries = 3;
    int attempt = 0;
    bool success = false;

    setState(() => isLoading = true);

    while (attempt < maxRetries && !success) {
      attempt++;

      final response =
          await PublicRoutesApiService.fetchMembersByChapter(widget.chapterId);

      if (response.isSuccess && response.data != null) {
        try {
          final List<othersMemberModel> members = (response.data as List)
              .map((e) => othersMemberModel.fromJson(e))
              .toList();

          if (members.isNotEmpty) {
            final cid = members.first.cidId;

            if (cid != null && cid.isNotEmpty) {
              await _fetchCidDetailsWithRetry(cid);
            }
          }

          setState(() {
            allMembers = members;
            filteredMembers = members;
            isLoading = false;
          });

          success = true;
        } catch (e) {
          break;
        }
      } else {
        if (attempt >= maxRetries) {
          setState(() => isLoading = false);
         
        }
      }
    }
  }

  Future<void> _fetchCidDetailsWithRetry(String cidId) async {
    const int maxRetries = 3;
    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;

      try {
        final response = await PublicRoutesApiService.fetchCidDetails(cidId);

        if (response.isSuccess && response.data != null) {
          final data = response.data;

          final profile = data['profileImage']; // ✅ correct key

          final member = othersMemberModel(
            id: data['_id'] ?? '',
            name: data['username'] ?? '',
            company: data['companyName'] ?? '',
            phone: data['mobileNumber'] ?? '',
            role: data['role']?['name'] ?? '',
            website: data['website'],
            chapterName: data['chapterName'],
            businessDescription: data['businessDescription'],
            email: data['email'] ?? '',
            address: data['address'],
            profileImageUrl: (profile != null)
                ? "${UrlService.imageBaseUrl}/${profile['docPath']}/${profile['docName']}"
                : null,
          );

          setState(() {
            _cidMember = member;
          });

          success = true;
        } else {}
      } catch (e) {}
    }

    if (!success) {}
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
      body: SizedBox.expand(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(3.w, 3.w, 3.w, 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
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
                        SizedBox(width: 5.w),
                        Text(
                          widget.chapterName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Tcolors.title_color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    isLoading
                        ? buildSearchBarExactShimmer()
                        : _buildSearchBar(),

                    SizedBox(height: 2.h),

                    /// CID Member (if exists)
                    if (_cidMember != null) ...[
                      // ✅ CID Member Header
                      isLoading
                          ? buildAllMembersTitleShimmer()
                          : Container(
                              width: 73.w,
                              height: 3.3.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
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

                      // ✅ CID Member Grid
                      GridView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 3.w,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return othersMemberCard(
                              member: _cidMember!, isCidMember: true);
                        },
                      ),
                      SizedBox(height: 2.h),
                    ] else if (isLoading) ...[
                      isLoading
                          ? buildAllMembersTitleShimmer() // 🔄 Show shimmer placeholder while loading CID member
                          : Container(
                              width: 73.w,
                              height: 3.3.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
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

                      // 🌀 CID Shimmer
                      buildShimmerGrid(itemCount: 1),

                      SizedBox(height: 2.h),
                    ],

                    /// All Members Label
                    isLoading
                        ? buildAllMembersTitleShimmer()
                        : Container(
                            width: 73.w,
                            height: 3.3.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
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

                    /// Members Grid
                    /// Members Gridr
                    isLoading
                        ? buildShimmerGrid(itemCount: 6)
                        : _buildMemberGrid(),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            /// Menu Items (Floating)
            if (isMenuOpen)
              Positioned(
                bottom: 11.h,
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
                      child: _menuItem(Icons.group_work, "One-To-One", () {
                        context.push('/onetoone');
                      }),
                    ),
                  ],
                ),
              ),

            /// Fixed Bottom Button
            Positioned(
              bottom: 2.h,
              left: 50.w - 25.w,
              child: Container(
                width: 50.w,
                height: 7.5.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Home Button
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to home
                      },
                      child: Container(
                        width: 11.w,
                        height: 11.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.home, color: Colors.white),
                      ),
                    ),

                    /// Add Button
                    // ➕ or ✖ Toggle Button
                    GestureDetector(
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
                      child: Container(
                        width: 5.h,
                        height: 5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xFFE53935), width: 2),
                        ),
                        child: Icon(
                          isMenuOpen ? Icons.close : Icons.add,
                          color: const Color(0xFFE53935),
                          size: 4.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
