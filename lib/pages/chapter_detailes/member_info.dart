import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class chapterdetails extends StatelessWidget {
  const chapterdetails({super.key});

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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back),
                ),
              ),

              SizedBox(height: 15),
              // Top Row with Back and Edit
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Text("About", style: TTextStyles.myprofile),
                ],
              ),
              SizedBox(height: 1.5.h),
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 10.w,
                  backgroundImage:
                      const AssetImage('assets/images/profile.png'),
                ),
              ),
              SizedBox(height: 1.5.h),
              // Name & Role
              const Center(
                child: Text(
                  "Dinesh Kumar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Center(
                child: Text(
                  "GRIP ARAM",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "As An Experienced Interior Designer, I Specialize In Creating Aesthetically Pleasing And Functional Spaces That Reflect The Unique Needs And Preferences Of My Clients.",
                  textAlign: TextAlign.left,
                  style: TTextStyles.profiledes,
                ),
              ),
              SizedBox(height: 2.5.h),
              // Contact Info
              infoRow(Icons.business, "Marvel Interiors"),
              infoRow(Icons.phone, "+91 9655545554"),
              infoRow(Icons.email, "Grip@Gmail.Com"),
              infoRow(Icons.language, "www.grip.com"),
              infoRow(Icons.location_on, "No.25/61,1st Street, Chennai-70."),
              infoRow(Icons.location_on, "www.linkedin.com/in/grip"),
              infoRow(Icons.badge, "GRIP"),
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
