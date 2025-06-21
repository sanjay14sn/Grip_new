import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:grip/components/bottomappbartemp.dart';
import 'package:grip/pages/homepage/customcard.dart';
import 'package:grip/pages/homepage/slider.dart';
import 'package:grip/utils/constants/Timages.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? _storedToken;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChapterDetails();
  }

  void _loadChapterDetails() async {
    const storage = FlutterSecureStorage();

    // 🔓 Read user_data from secure storage
    final userDataString = await storage.read(key: 'user_data');

    if (userDataString == null) {
      print('❌ No user data found in secure storage.');
      return;
    }

    final Map<String, dynamic> userData = jsonDecode(userDataString);
    final chapterId = userData['chapterId'];

    if (chapterId == null) {
      print('❌ No chapterId found in user data.');
      return;
    }

    print('📥 Fetched chapterId from storage: $chapterId');

    // 📡 Fetch chapter details
    final provider = Provider.of<ChapterProvider>(context, listen: false);
    await provider.fetchChapterDetails(chapterId);

    final details = provider.chapterDetails;
    final members = provider.members;

    if (details != null) {
      print('📘 Chapter Name: ${details.chapterName}');
      print(
          '🌍 Location: ${details.meetingVenue}, ${details.stateName}, ${details.countryName}');
      print('📅 Meeting Time: ${details.meetingDayAndTime}');
      print('📌 Meeting Type: ${details.meetingType}');
      print('🧭 Zone: ${details.zoneName}');
      print('👤 CID: ${details.cidName} (${details.cidEmail})');
      print('👥 Members:');
      for (var member in members) {
        print(
            '  🔹 ${member.name} | ${member.email} | ${member.mobileNumber} | ${member.id}');
      }
    } else {
      print('⚠️ No chapter details available.');
    }
  }

  void _loadUserData() async {
    const storage = FlutterSecureStorage();
    final userDataJson = await storage.read(key: 'user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      setState(() {
        _username = userData['username']; // e.g., Kumar R
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, 8.0, 8.0, 8.0), // Left: 0, Top/Right/Bottom: 8
                  child: Image.asset(Timages.griplogo, height: 40, width: 100),
                ),

                // Top section with user info, avatar, and notification icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Welcome text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, ${_username ?? 'User'}", // ✅ Dynamic
                            style: TTextStyles.usernametitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Let's connect, communicate and collaborate",
                            style: TTextStyles.usersubtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () {
                        context.push('/profilepage');
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        radius: 25,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    // Notification Icon
                    GestureDetector(
                      onTap: () {
                        context.push('/notifications');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            Timages.noficationicon,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                Center(child: ReferralCarousel()),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referrals',
                      style: TTextStyles.customcard,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Total Referral",
                      value: "95+",
                      onTapAddView: () {
                        context.push('/addreferalpage');
                      },
                      onTapView: () => context.push('/referralview'),
                      imagePath: 'assets/images/referralmain.png',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Thank U Notes',
                      style: TTextStyles.customcard,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Thank U Notes",
                      value: "10+",
                      onTapAddView: () {
                        context.push('/thankyounote');
                      },
                      onTapView: () {
                        context.push('/thankyouview');
                      },
                      imagePath: 'assets/images/handshake.png',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Testimonials',
                      style: TTextStyles.customcard,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Testimonials",
                      value: "8+",
                      onTapAddView: () {
                        context.push('/addtestimonials');
                      },
                      onTapView: () {
                        context.push('/testimonialview');
                      },
                      imagePath:
                          'assets/images/fluent_person-feedback-16-filled.png',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'one-to-ones',
                      style: TTextStyles.customcard,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    Customcard(
                      title: "One-to-Ones",
                      value: "12+",
                      onTapAddView: () => context.push('/onetoone'),
                      onTapView: () => context.push('/viewone'),
                      imagePath: 'assets/images/testimonials.png',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Visitors',
                      style: TTextStyles.customcard,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Visitors",
                      value: "20+",
                      onTapAddView: () {
                        context.push('/visitors');
                      },
                      onTapView: () => {context.push('/visitorsview')},
                      imagePath: 'assets/images/visitors.png',
                    ),
                  ],
                ),
                SizedBox(height: 4.h)
              ],
            ),
          )),

      // bottomNavigationBar:CurvedBottomNavBar(), // <-- This adds the bottom bar
      bottomNavigationBar: CurvedBottomNavBar(), // <-- This adds the bottom bar
    );
  }
}
