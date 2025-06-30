import 'package:flutter/material.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ChapterDetails extends StatefulWidget {
  final MemberModel member;

  const ChapterDetails({super.key, required this.member});

  @override
  State<ChapterDetails> createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterDetails> {
  bool isMenuOpen = true;

  @override
  Widget build(BuildContext context) {
    final isCID = widget.member.role?.toLowerCase() == 'cid';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
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

              // Menu right below "About"
              if (!isCID)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _menuItem(Icons.group, "Referrals", () {
                          context.push('/Othersreferral');
                        }),
                        _menuItem(Icons.chat, "Testimonials", () {
                          context.push('/OthersTestimonial');
                        }),
                        _menuItem(Icons.group_work, "One-To-Ones", () {}),
                        _menuItem(Icons.remove_red_eye_sharp, "Visitors", () {
                          context.push('/Othersvisitors');
                        }),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),

              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 10.w,
                  backgroundImage:
                      const AssetImage('assets/images/profile.png'),
                ),
              ),
              SizedBox(height: 1.5.h),

              // Name & Role
              Center(
                child: Text(
                  widget.member.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  widget.member.role ?? "Member",
                  style: const TextStyle(
                    color: Color(0xFFC83837),
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
                  widget.member.businessDescription ?? "No Description",
                  textAlign: TextAlign.left,
                  style: TTextStyles.profiledes,
                ),
              ),
              SizedBox(height: 2.5.h),

              // Contact Info
              infoRow(Icons.business, widget.member.company),
              infoRow(Icons.phone, widget.member.phone),
              infoRow(Icons.email, widget.member.email ?? 'N/A'),
              infoRow(Icons.language, widget.member.website ?? 'N/A'),
              infoRow(Icons.location_on, widget.member.address ?? 'N/A'),
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

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: Tcolors.red_button,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
