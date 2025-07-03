import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? memberData;
  const ProfilePage({super.key, this.memberData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    print("🔍 memberData: ${widget.memberData}");
  }

  void _handleLogout(BuildContext context) async {
    const storage = FlutterSecureStorage();

    // ✅ Preserve FCM token
    final fcmToken = await storage.read(key: 'fcm_token');

    // 🔐 Delete everything
    await storage.deleteAll();

    // ✅ Restore FCM token
    if (fcmToken != null) {
      await storage.write(key: 'fcm_token', value: fcmToken);
    }

    // 🔄 Navigate to login
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.memberData ?? {};
    final personal = data['personalDetails'] ?? {};
    final chapter = data['chapterInfo'] ?? {};
    final business = data['businessDetails'] ?? {};
    final contact = data['contactDetails'] ?? {};
    final address = data['businessAddress'] ?? {};

    final fullName =
        '${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}';
    final company = personal['companyName'] ?? '-';
    final mobile = contact['mobileNumber'] ?? '-';
    final email = contact['email'] ?? '-';
    final website = contact['website'] ?? '-';
    final location =
        '${address['addressLine1'] ?? ''}, ${address['city'] ?? ''}';
    final chapterName = chapter['chapterId']?['chapterName'] ?? '-';
    final description =
        business['businessDescription'] ?? 'No description provided.';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Text("My Profile", style: TTextStyles.myprofile),
                  const Spacer(),
                  // Text("Edit", style: TTextStyles.Editprofile),
                ],
              ),
              SizedBox(height: 2.h),
              Center(
                child: CircleAvatar(
                  radius: 10.w,
                  backgroundImage: (widget.memberData?['personalDetails']
                              ?['profileImage'] !=
                          null)
                      ? NetworkImage(
                          "${UrlService.imageBaseUrl}/${widget.memberData!['personalDetails']['profileImage']['docPath']}/${widget.memberData!['personalDetails']['profileImage']['docName']}",
                        )
                      : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
                ),
              ),
              SizedBox(height: 1.5.h),
              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  chapterName,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(height: 2.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TTextStyles.profiledes,
                ),
              ),
              SizedBox(height: 2.5.h),
              infoRow(Icons.business, company),
              infoRow(Icons.phone, mobile),
              infoRow(Icons.email, email),
              infoRow(Icons.language, website),
              infoRow(Icons.location_on, location),
              infoRow(Icons.link, 'www.linkedin.com/in/grip'),
              infoRow(Icons.badge, chapterName),
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
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
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
