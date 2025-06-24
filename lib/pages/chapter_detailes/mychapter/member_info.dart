import 'package:flutter/material.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ChapterDetails extends StatelessWidget {
  final MemberModel member;

  const ChapterDetails({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 15),

              // Header
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Text("About", style: TTextStyles.myprofile),
                ],
              ),
              SizedBox(height: 1.5.h),

              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 10.w,
                  backgroundImage: const AssetImage('assets/images/profile.png'),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Name & Role
              Center(
                child: Text(
                  member.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  // member.chapterName,
                  "Member",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  member.businessDescription ?? "No Description",
                  textAlign: TextAlign.left,
                  style: TTextStyles.profiledes,
                ),
              ),
              SizedBox(height: 2.5.h),

              // Contact Info
              infoRow(Icons.business, member.company),
              infoRow(Icons.phone, member.phone),
              infoRow(Icons.email, member.email ?? 'N/A'),
              infoRow(Icons.language, member.website ?? 'N/A'),
              infoRow(Icons.location_on, member.address ?? 'N/A'),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Icon(icon, size: 18),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: TTextStyles.profiledetails,
            ),
          ),
        ],
      ),
    );
  }
}
