import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:grip/components/bottomappbartemp.dart';
import 'package:grip/pages/allcount.dart';
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
  List<dynamic> _allvisitors = [];
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
  // Loading flags

  bool _isOneToOneLoading = true;
  bool _isTestimonialLoading = true;

  bool _isVisitorLoading = true;
  bool _isSevenDayVisitorLoading = true;

// Error flags
  bool _hasReferralError = false;
  bool _hasOneToOneError = false;
  bool _hasTestimonialError = false;
  bool _hasThankYouError = false;
  bool _hasVisitorError = false;
  bool _hasSevenDayVisitorError = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChapterDetails();
    fetchMember();
    Future.delayed(const Duration(milliseconds: 1000), _loadAllDashboardData);
  }

// Add this helper method to your state class
  Future<void> _runWithRetry(
    Future<void> Function() apiCall, {
    String apiName = '',
    void Function(bool)? setLoading,
  }) async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 1);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        if (setLoading != null) setLoading(true);
        await apiCall();
        return;
      } catch (e) {
        print("⚠️ $apiName attempt $attempt failed: $e");
        if (attempt == maxRetries) rethrow;
        await Future.delayed(retryDelay);
      } finally {
        if (setLoading != null) setLoading(false);
      }
    }
  }

  Future<void> _loadAllDashboardData() async {
    await _runWithRetry(_loadVisitors, apiName: 'Visitors');
    await Future.delayed(const Duration(milliseconds: 300));

    await _runWithRetry(_loadOneToOneList, apiName: 'One-to-One');
    await Future.delayed(const Duration(milliseconds: 300));

    await _runWithRetry(_loadTestimonials, apiName: 'Testimonials');
    await Future.delayed(const Duration(milliseconds: 300));

    await _runWithRetry(() async {
      await _loadReferralSlips();
    }, apiName: 'Referrals');
    await Future.delayed(const Duration(milliseconds: 300));

    await _runWithRetry(() async {
      await _loadThankYouNotes();
    }, apiName: 'Thank You Notes');
    await Future.delayed(const Duration(milliseconds: 300));

    await _runWithRetry(() async {
      await _loadVisitorsData();
    }, apiName: 'Seven Days Visitor');
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
    } else {}
  }

  void _loadChapterDetails() {
    _runWithRetry(() async {
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
    }, apiName: 'Fetch Chapter Details');
  }

  Future<void> _loadOneToOneList() async {
    print('📡 Fetching One-to-One list from API...');
    try {
      if (mounted) setState(() => _isOneToOneLoading = true); // ✅ start

      final response = await PublicRoutesApiService.getOneToOneList();

      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        setState(() {
          _oneToOneList = response.data;
          _oneToOneCount = response.extra?['total'] ?? response.data.length;
          _hasOneToOneError = false;
        });
      } else {
        setState(() {
          _oneToOneList = [];
          _oneToOneCount = 0;
          _hasOneToOneError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _oneToOneList = [];
          _oneToOneCount = 0;
          _hasOneToOneError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isOneToOneLoading = false); // ✅ finish
    }
  }

  Future<void> _loadVisitors() async {
    print('📡 Fetching visitor list from API...');
    try {
      if (mounted) setState(() => _isVisitorLoading = true); // ✅ set loading

      final response = await PublicRoutesApiService.getVisitorsList();

      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        setState(() {
          _visitors = response.data;
          _visitorCount = response.extra?['total'] ?? response.data.length;
          _hasVisitorError = false;
        });
      } else {
        setState(() {
          _visitorCount = 0;
          _visitors = [];
          _hasVisitorError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _visitorCount = 0;
          _visitors = [];
          _hasVisitorError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isVisitorLoading = false); // ✅ done
    }
  }

  Future<void> _loadTestimonials() async {
    print('📡 Fetching testimonials...');
    try {
      if (mounted)
        setState(() => _isTestimonialLoading = true); // ✅ use correct flag

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
          _hasTestimonialError = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _testimonialList = [];
          _testimonialCount = 0;
          _hasTestimonialError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isTestimonialLoading = false); // ✅ reset
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

          print("Failed to load referrals: ${response.message}");
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
        ToastUtil.showToast(context, "Network error. Please try again later.");
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
        print(' Failed to fetch Thank You Notes: ${response.message}');
      }
    } catch (e) {
      print("Error loading thank you notes: $e");
      if (mounted) {
        ToastUtil.showToast(context, "Network error loading Thank You Notes");
      }
    }
  }

  void fetchMember() {
    _runWithRetry(() async {
      const storage = FlutterSecureStorage();
      final userDataJson = await storage.read(key: 'user_data');

      if (userDataJson != null) {
        final userData = jsonDecode(userDataJson);
        final String memberId = userData['id'];

        final response =
            await PublicRoutesApiService.fetchMemberDetailsById(memberId);

        // ✅ Print individual fields of the response
        print('📡 isSuccess: ${response.isSuccess}');
        print('📝 message: ${response.message}');
        print('📦 datamember1: ${response.data}');

        if (response.isSuccess && response.data != null) {
          setState(() {
            _memberData = response.data;
          });
        } else {
          ToastUtil.showToast(context, 'Network error loading member details');
          print('❌ API returned failure or null data');
        }
      } else {
        print('❌ No user data found for member fetch');
      }
    }, apiName: 'Fetch Member Details');
  }

  Future<void> _loadVisitorsData() async {
    const storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');
    if (userDataString == null) return;

    final userData = jsonDecode(userDataString);
    final chapterId = userData['chapterId'];

    final response = await PublicRoutesApiService.fetchVisitors(chapterId);
    if (response.isSuccess) {
      print('🟢 Visitors fetched: ${response.data}');
      setState(() {
        _allvisitors = response.data; // ✅ Store it here
      });
    } else {
      print('🔴 Visitors fetch failed: ${response.message}');
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
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 👤 Profile + 🔔 Notification on the Left
                      Row(
                        children: [
                          // Profile
                          GestureDetector(
                            onTap: () {
                              context.push('/profilepage', extra: _memberData);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: (_memberData?['personalDetails']
                                          ?['profileImage'] !=
                                      null)
                                  ? NetworkImage(
                                      "${UrlService.imageBaseUrl}/${_memberData?['personalDetails']['profileImage']['docPath']}/${_memberData?['personalDetails']['profileImage']['docName']}",
                                    )
                                  : const AssetImage(
                                          'assets/images/profile.png')
                                      as ImageProvider,
                            ),
                          ),
                          SizedBox(width: 3.w),

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
                          ),
                        ],
                      ),

                      // 🅶 Grip Logo on the Right
                      Image.asset(
                        Timages.griplogo,
                        height: 40,
                        width: 100,
                      ),
                    ],
                  ),
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
                            "${_username ?? 'User'}", // ✅ Dynamic
                            style: TTextStyles.usernametitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "${_memberData?['chapterInfo']?['chapterId']?['chapterName'] ?? 'Chapter'}",
                            style: TTextStyles.usersubtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "Renewal date : 18th July 2026",
                            style: TTextStyles.usersubtitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                  ],
                ),
                const SizedBox(height: 20),

                Center(child: ReferralCarousel()),
                SizedBox(
                  height: 1.h,
                ),
                HomeDashboard(), // or wherever your home page is.
                SizedBox(height: 1.5.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Referrals',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Referrals",
                      value: _isReferralLoading
                          ? '...'
                          : _hasReferralError
                              ? '0'
                              : '$_referralCount',
                      onTapAddView: () async {
                        final result = await context.push('/addreferalpage');
                        if (result == true) await _loadReferralSlips();
                      },
                      onTapView: () {
                        context.push('/referralview', extra: _referralList);
                      },
                      imagePath: 'assets/images/referralmain.png',
                    ),
                    SizedBox(height: 16),
                    Text('One-to-One',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "One-to-One",
                      value: _isOneToOneLoading
                          ? '...'
                          : _hasOneToOneError
                              ? '0'
                              : '$_oneToOneCount',
                      onTapAddView: () async {
                        final result = await context.push('/onetoone');
                        if (result == true) await _loadOneToOneList();
                      },
                      onTapView: () {
                        context.push('/viewone', extra: _oneToOneList);
                      },
                      imagePath: 'assets/images/testimonials.png',
                    ),
                    SizedBox(height: 16),
                    Text('Thank U Notes',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Thank U Notes",
                      value: _isThankYouLoading
                          ? '...'
                          : _hasThankYouError
                              ? '0'
                              : '$_thankYouCount',
                      onTapAddView: () async {
                        final result = await context.push('/thankyounote');
                        if (result == true) await _loadThankYouNotes();
                      },
                      onTapView: () {
                        context.push('/thankyouview', extra: _givenNotes);
                      },
                      imagePath: 'assets/images/handshake.png',
                    ),
                    SizedBox(height: 16),
                    Text('Testimonials',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Testimonials",
                      value: _isTestimonialLoading
                          ? '...'
                          : _hasTestimonialError
                              ? '0'
                              : '$_testimonialCount',
                      onTapAddView: () async {
                        final result = await context.push('/addtestimonials');
                        if (result == true) await _loadTestimonials();
                      },
                      onTapView: () {
                        context.push('/viewtestimonials',
                            extra: _testimonialList);
                      },
                      imagePath:
                          'assets/images/fluent_person-feedback-16-filled.png',
                    ),
                    SizedBox(height: 16),
                    Text('Visitors',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Visitors",
                      value: _isVisitorLoading
                          ? '...'
                          : _hasVisitorError
                              ? '0'
                              : '$_visitorCount',
                      onTapAddView: () async {
                        final result = await context.push('/visitors');
                        if (result == true) await _loadVisitors();
                      },
                      onTapView: () {
                        context.push('/visitorsview', extra: _visitors);
                      },
                      imagePath: 'assets/images/visitors.png',
                    ),
                    SizedBox(height: 16),
                    Text('Chapter Visitors',
                        style: TTextStyles.customcard,
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    Customcard(
                      title: "Chapter Visitors – ( Last 7 Days )",
                      value: '${_allvisitors.length}',
                      onTapAddView: () {},
                      onTapView: () async {
                        final result = await context.push('/allvisitors',
                            extra: _allvisitors);
                        if (result == true) await _loadVisitorsData();
                      },
                      imagePath: 'assets/images/visitors.png',
                      viewOnly: true,
                    ),
                  ],
                ),
                SizedBox(height: 8.h)
              ],
            ),
          )),
      bottomNavigationBar: CurvedBottomNavBar(), // <-- This adds the bottom bar
    );
  }
}
