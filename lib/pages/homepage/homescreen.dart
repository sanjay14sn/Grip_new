import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:grip/components/bottomappbartemp.dart';
import 'package:grip/pages/homepage/customcard.dart';
import 'package:grip/pages/homepage/slider.dart';
import 'package:grip/pages/toastutill.dart';
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
  List<dynamic> _visitors = [];
  bool _isLoading = true;
  int _visitorCount = 0;
  List<dynamic> _oneToOneList = [];
  int _oneToOneCount = 0;
  int _testimonialCount = 0;
  List<dynamic> _testimonialList = [];
  bool _isReferralLoading = true;
  int _referralCount = 0;
  List<dynamic> _referralList = [];
  List<dynamic> _givenNotes = [];
  bool _isThankYouLoading = true;
  String? _memberId;
  Map<String, dynamic>? _memberData; // at top of your state class

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChapterDetails();
    _loadVisitors();
    _loadOneToOneList();
    _loadTestimonials();
    _loadReferralSlips();
    _loadThankYouNotes();
    fetchMember();
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

  Future<void> _loadOneToOneList() async {
    print('📡 Fetching One-to-One list from API...');

    final response = await PublicRoutesApiService.getOneToOneList();

    if (response.isSuccess && response.data != null) {
      print('✅ One-to-One list fetched successfully.');
      print('📦 Total records (from extra): ${response.extra?['total']}');
      print('📦 Total records (from data.length): ${response.data.length}');

      for (var item in response.data) {
        print(
            '👥 From: ${item['fromMember']?['personalDetails']?['firstName']} '
            'To: ${item['toMember']?['personalDetails']?['firstName']}');
      }

      setState(() {
        _oneToOneList = response.data;
        _oneToOneCount = response.extra?['total'] ?? response.data.length;
        _isLoading = false;
      });
    } else {
      print('❌ Failed to fetch One-to-One list: ${response.message}');
      setState(() => _isLoading = false);
      ToastUtil.showToast(context,'❌ ${response.message}');
    }
  }

  Future<void> _loadVisitors() async {
    print('📡 Fetching visitor list from API...');

    final response = await PublicRoutesApiService.getVisitorsList();

    if (response.isSuccess && response.data != null) {
      print('✅ Visitor list fetched successfully.');
      print('📦 Total Visitors from pagination: ${response.extra?['total']}');

      setState(() {
        _visitors = response.data;
        _visitorCount = response.extra?['total'] ?? response.data.length;
        _isLoading = false;
      });
    } else {
      print('❌ Failed to fetch visitors: ${response.message}');
      ToastUtil.showToast(context,'❌ ${response.message}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadUserData() async {
    const storage = FlutterSecureStorage();
    final userDataJson = await storage.read(key: 'user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      final memberId = userData['id']; // 👈 Member ID

      setState(() {
        _username = userData['username']; // e.g., Kumar R
        // Store memberId to state variable if needed
        _memberId = memberId;
      });

      print('👤 Username: $_username');
      print('🆔 Member ID: $memberId');
    } else {
      print('❌ No user data found.');
    }
  }

  Future<void> _loadTestimonials() async {
    setState(() => _isLoading = true);

    final response = await PublicRoutesApiService.getTestimonialGivenList();

    if (response.isSuccess && response.data != null) {
      setState(() {
        _testimonialList = response.data;
        _testimonialCount = _testimonialList.length;
      });
    } else {
      setState(() {
        _testimonialList = [];
        _testimonialCount = 0;
      });
      ToastUtil.showToast(context,"❌ ${response.message}");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadReferralSlips() async {
    print("🔄 Loading referral slips...");

    final response = await PublicRoutesApiService.getReferralGivenList();

    print("✅ API Response received.");
    print("➡️ Success: ${response.isSuccess}");
    print("➡️ Message: ${response.message}");
    print("➡️ Data: ${response.data}");

    if (mounted) {
      setState(() {
        _isReferralLoading = false;

        if (response.isSuccess) {
          _referralList = response.data ?? [];
          _referralCount = _referralList.length;

          print("📦 Referral list loaded with ${_referralCount} items.");
        } else {
          print("❌ Failed to load referrals: ${response.message}");
          ToastUtil.showToast(context,response.message);
        }
      });
    }
  }

  Future<void> _loadThankYouNotes() async {
    print('📦 Loading Thank You Notes...');

    final response = await PublicRoutesApiService.fetchGivenThankYouNotes();

    if (response.isSuccess && response.data is List) {
      final notes = response.data as List<dynamic>;
      print('✅ Successfully fetched ${notes.length} Thank You Notes');

      for (var i = 0; i < notes.length; i++) {
        print('📝 Note $i: ${notes[i]}');
      }

      setState(() {
        _givenNotes = notes;
        _isThankYouLoading = false;
      });
    } else {
      print('❌ Failed to fetch Thank You Notes: ${response.message}');
      setState(() => _isThankYouLoading = false);
      ToastUtil.showToast(context,"❌ Failed to load Thank You Notes");
    }
  }

  void fetchMember() async {
    const storage = FlutterSecureStorage();
    final userDataJson = await storage.read(key: 'user_data');

    if (userDataJson != null) {
      final userData = jsonDecode(userDataJson);
      final String memberId = userData['id'];

      final response =
          await PublicRoutesApiService.fetchMemberDetailsById(memberId);

      if (response.isSuccess && response.data != null) {
        setState(() {
          _memberData = response.data;
        });

        print(
            '✅ Member loaded for profile: ${_memberData!['personalDetails']['firstName']}');
      } else {
        ToastUtil.showToast(context,'❌ Failed to load member');
      }
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
                       
                          context.push('/profilepage', extra: _memberData);
                        
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
                      value: _isReferralLoading ? '0' : '$_referralCount+',
                      onTapAddView: () async {
                        final result = await context.push('/addreferalpage');
                        if (result == true) {
                          await _loadReferralSlips(); // Refresh count if new added
                        }
                      },
                      onTapView: () {
                        context.push('/referralview',
                            extra: _referralList); // 👈 pass data
                      },
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
                      value:
                          _isThankYouLoading ? '0' : "${_givenNotes.length}+",
                      onTapAddView: () {
                        context.push('/thankyounote');
                      },
                      onTapView: () {
                        context.push('/thankyouview',
                            extra: _givenNotes); // pass data via `extra`
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
                      value: _isLoading ? '0' : '$_testimonialCount+',
                      onTapAddView: () async {
                        final result = await context.push('/addtestimonials');
                        if (result == true) {
                          await _loadTestimonials(); // 👈 reload after adding
                        }
                      },
                      onTapView: () {
                        context.push('/viewtestimonials',
                            extra: _testimonialList);
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
                      value: _isLoading ? '0' : '$_oneToOneCount+',
                      onTapAddView: () async {
                        final result = await context.push('/onetoone');
                        if (result == true) {
                          await _loadOneToOneList();
                        }
                      },
                      onTapView: () {
                        context.push('/viewone', extra: _oneToOneList);
                      },
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
                      value: _isLoading ? '0' : '$_visitorCount+',
                      onTapAddView: () async {
                        final result = await context.push('/visitors');
                        if (result == true) {
                          await _loadVisitors(); // 👈 triggers update
                        }
                      },
                      onTapView: () {
                        context.push('/visitorsview', extra: _visitors);
                      },
                      imagePath: 'assets/images/visitors.png',
                    ),
                  ],
                ),
                SizedBox(height: 4.h)
              ],
            ),
          )),
      bottomNavigationBar: CurvedBottomNavBar(), // <-- This adds the bottom bar
    );
  }
}
