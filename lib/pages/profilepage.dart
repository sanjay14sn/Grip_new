import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) async {
    const storage = FlutterSecureStorage();

    // 🧹 Clear all secure storage values
    await storage.deleteAll();

    print('🚪 User logged out. Secure storage cleared.');

    // 🔄 Navigate to login screen
    context.go('/login');
  }

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
                  Text("My Profile", style: TTextStyles.myprofile),
                  const Spacer(),
                  Text("Edit", style: TTextStyles.Editprofile),
                ],
              ),
              SizedBox(height: 2.h),
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
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.push('/membershipdetails');
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(1
                          .w), // Outer padding - controls thickness of gradient border
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E8DDB), Color(0xFFE14F4F)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 1.2.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Text(
                          'Membership',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFF00BFA6), Color(0xFFE14F4F)],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                          ),
                        ),
                      ),
                    ),
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
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 3.5.h,
                  width: 22.5.w,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: Tcolors.red_button,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _handleLogout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
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
