import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  bool isExpanded = true;
  String searchText = '';
  String? selectedMember;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    const storage = FlutterSecureStorage();
    final userData = await storage.read(key: 'user_data');
    if (userData != null) {
      final decoded = jsonDecode(userData);
      setState(() {
        currentUserId = decoded['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapterProvider = Provider.of<ChapterProvider>(context);
    final chapter = chapterProvider.chapterDetails;
    final memberList = chapterProvider.members;

    // 🧠 Filter out current user and match search text
    final filteredMembers = memberList
        .where((member) =>
            member.name.toLowerCase().contains(searchText.toLowerCase()) &&
            member.id != currentUserId)
        .toList();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.w),
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
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC83837),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "OTHERS ONE TO ONES",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Dummy space to balance the row (same width as back button)
                      SizedBox(
                          width:
                              48), // or use IconButton(icon: Icon(null)) if needed
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFFC83837)),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                searchText = val;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Color(0xFFC83837),
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${chapter?.chapterName ?? 'Chapter'} Members List:",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Color(0xFFC83837),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final isSelected = member.name == selectedMember;

                            return ListTile(
                                dense: true,
                                title: Text(
                                  member.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Color(0xFFC83837)
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    selectedMember = member.name;
                                  });

                                  print("👤 Name: ${member.name}");
                                  print("📞 Mobile: ${member.mobileNumber}");
                                  print("🆔 UID: ${member.id}");

                                  final response = await PublicRoutesApiService
                                      .fetchOthersOneToOnes(member.id);

                                  if (response.isSuccess &&
                                      response.data != null) {
                                    // Pass data to next page via extra
                                    context.push('/OthersOneToOnesPage',
                                        extra: response.data);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response.message ??
                                              "Failed to load data")),
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
