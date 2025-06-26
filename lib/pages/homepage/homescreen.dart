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
  int _thankYouCount = 0;

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
    fetchMember();

    // Add slight delay before loading data
    Future.delayed(const Duration(milliseconds: 1000), _loadAllDashboardData);
  }

// Add this helper method to your state class
  Future<void> _runWithRetry(Future<void> Function() apiCall,
      {String apiName = ''}) async {
    const maxRetries = 2;
    const retryDelay = Duration(seconds: 1);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await apiCall();
        return; // Success - exit loop
      } catch (e) {
        print("⚠️ $apiName attempt $attempt failed: $e");
        if (attempt == maxRetries) {
          print("❌ All retries exhausted for $apiName");
          rethrow;
        }
        await Future.delayed(retryDelay);
      }
    }
  }

// Update _loadAllDashboardData
  Future<void> _loadAllDashboardData() async {
    // final connectivity = await Connectivity().checkConnectivity();
    // if (connectivity == ConnectivityResult.none) {
    //   print("❌ Skipping dashboard data fetch: No internet");
    //   return;
    // }

    final apis = [
      () => _runWithRetry(_loadVisitors, apiName: 'Visitors'),
      () => _runWithRetry(_loadOneToOneList, apiName: 'One-to-One'),
      () => _runWithRetry(_loadTestimonials, apiName: 'Testimonials'),
      () => _runWithRetry(_loadReferralSlips, apiName: 'Referrals'),
      () => _runWithRetry(_loadThankYouNotes, apiName: 'Thank You Notes'),
    ];

    for (final api in apis) {
      try {
        await api();
      } catch (e) {
        print("🚨 API failed after retries: $e");
        // Individual APIs handle their own errors
      }
    }
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

    try {
      final response = await PublicRoutesApiService.getOneToOneList();

      if (!mounted) return;

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
        if (mounted) {
          setState(() => _isLoading = false);
          ToastUtil.showToast(context, '❌ ${response.message}');
        }
      }
    } catch (e) {
      print("🚨 Error in _loadOneToOneList: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ToastUtil.showToast(context, "🚨 Error loading One-to-One list");
      }
    }
  }

  Future<void> _loadVisitors() async {
    print('📡 Fetching visitor list from API...');

    try {
      final response = await PublicRoutesApiService.getVisitorsList();

      if (!mounted) return;

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
        if (mounted) {
          ToastUtil.showToast(context, '❌ ${response.message}');
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print("🚨 Critical error in _loadVisitors: $e");
      if (mounted) {
        setState(() {
          _visitors = [];
          _visitorCount = 0;
          _isLoading = false;
        });
      }
      rethrow; // Important for retry mechanism
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
    print('📡 Fetching testimonials...');

    try {
      if (mounted) setState(() => _isLoading = true);

      final response = await PublicRoutesApiService.getTestimonialGivenList();

      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        final data = response.data;

        if (data is List) {
          setState(() {
            _testimonialList = data;
            _testimonialCount = response.extra?['total'] ?? data.length;
          });
        } else {
          setState(() {
            _testimonialList = [];
            _testimonialCount = 0;
          });
          ToastUtil.showToast(context, "⚠️ Unexpected data format.");
        }
      } else {
        setState(() {
          _testimonialList = [];
          _testimonialCount = 0;
        });
        ToastUtil.showToast(context, "❌ ${response.message}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _testimonialList = [];
          _testimonialCount = 0;
        });
        ToastUtil.showToast(context, "🚨 Error loading testimonials: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadReferralSlips() async {
    print("🔄 Loading referral slips...");

    try {
      final response = await PublicRoutesApiService.getReferralGivenList();

      print("✅ API Response received.");
      print("➡️ Success: ${response.isSuccess}");
      print("➡️ Message: ${response.message}");

      if (!mounted) return;

      setState(() {
        _isReferralLoading = false;

        if (response.isSuccess) {
          _referralList = response.data ?? [];
          _referralCount = response.extra?['total'] ?? _referralList.length;
          print(
              "📦 Referrals loaded: ${_referralList.length} shown, total: $_referralCount");
        } else {
          _referralList = [];
          _referralCount = 0;
          ToastUtil.showToast(context, '❌ ${response.message}');
          print("❌ Failed to load referrals: ${response.message}");
        }
      });
    } catch (e) {
      print("🚨 Exception while loading referrals: $e");
      if (mounted) {
        setState(() {
          _isReferralLoading = false;
          _referralList = [];
          _referralCount = 0;
        });
        ToastUtil.showToast(
            context, "🚨 Network error. Please try again later.");
      }
    }
  }

  Future<void> _loadThankYouNotes() async {
    print('📦 Loading Thank You Notes...');

    try {
      final response = await PublicRoutesApiService.fetchGivenThankYouNotes();

      if (!mounted) return;
      setState(() => _isThankYouLoading = false);

      if (response.isSuccess && response.data is List) {
        final notes = response.data as List<dynamic>;
        final int total = response.extra?['total'] ?? notes.length;

        print('✅ Successfully fetched ${notes.length} notes (total: $total)');

        setState(() {
          _givenNotes = notes;
          _thankYouCount = total;
        });
      } else {
        print('❌ Failed to fetch Thank You Notes: ${response.message}');
        ToastUtil.showToast(context, "❌ Failed to load Thank You Notes");
      }
    } catch (e) {
      print("🚨 Error loading thank you notes: $e");
      if (mounted) {
        ToastUtil.showToast(
            context, "🚨 Network error loading Thank You Notes");
      }
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
      } else {
        ToastUtil.showToast(context, '❌ Failed to load member');
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
                      value: _isThankYouLoading ? '0' : '$_thankYouCount+',
                      onTapAddView: () async {
                        final result = await context.push('/thankyounote');
                        if (result == true) {
                          await _loadThankYouNotes(); // 👈 reload after adding
                        }
                      },
                      onTapView: () {
                        context.push('/thankyouview', extra: _givenNotes);
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
                      'One-to-Ones',
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
