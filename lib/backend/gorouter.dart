import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/Registration.dart';
import 'package:grip/components/attandance_sucessfull.dart';
import 'package:grip/components/failure_attandance.dart';
import 'package:grip/networkerror.dart';
import 'package:grip/pages/Editprofile.dart';
import 'package:grip/pages/Eventpage.dart';
import 'package:grip/pages/chapter_detailes/chapterdetails.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/pages/chapter_detailes/mychapter/member_info.dart';
import 'package:grip/pages/chapter_detailes/otherchapter/otherchaptersproile.dart';
import 'package:grip/pages/mainsplashscreen.dart';
import 'package:grip/pages/meeting.dart';
import 'package:grip/pages/navigator_key.dart';
import 'package:grip/pages/one_to_one/given_onetoone.dart';
import 'package:grip/pages/one_to_one/recived_one_to_one.dart';
import 'package:grip/pages/one_to_one/viewone_to_one.dart';
import 'package:grip/pages/one_to_one/viewmembers.dart';
import 'package:grip/pages/othersview.dart/otherreferral.dart';
import 'package:grip/pages/othersview.dart/otherstest.dart';
import 'package:grip/pages/othersview.dart/othersvisitors.dart';
import 'package:grip/pages/payment/membershipdetails.dart';
import 'package:grip/pages/qrscanner.dart';
import 'package:grip/pages/referrals/receivedreferral.dart';
import 'package:grip/pages/testimonials/given_test.dart';
import 'package:grip/pages/testimonials/received_test.dart';
import 'package:grip/pages/thankunote/giventhanku.dart';
import 'package:grip/pages/thankunote/recivedthankyou.dart';
import 'package:grip/pages/thankunote/thankyouview.dart';
import 'package:grip/pages/notifications.dart';
import 'package:grip/pages/referrals/addreferrals.dart';
import 'package:grip/pages/homepage/homescreen.dart';
import 'package:grip/pages/loginpage.dart';
import 'package:grip/pages/one_to_one/one_to_one.dart';
import 'package:grip/pages/profilepage.dart';
import 'package:grip/pages/referrals/givenrefferel.dart';
import 'package:grip/pages/referrals/referalview.dart';
import 'package:grip/pages/splashscreen.dart';
import 'package:grip/pages/testimonials/addtestimonials.dart';
import 'package:grip/pages/testimonials/testimonialsview.dart';
import 'package:grip/pages/thankunote/thankyounote.dart';
import 'package:grip/pages/timeout.dart';
import 'package:grip/pages/visitors/allchaptervisitors.dart';
import 'package:grip/pages/visitors/visitors.dart';
import 'package:grip/pages/visitors/visitors_detailed.dart';
import 'package:grip/pages/visitors/visitors_view.dart';

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey, // ✅ Pass it here
  initialLocation: '/gripsplashscreen',
  routes: [
    GoRoute(
      path: '/gripsplashscreen',
      builder: (context, state) => GripSplashScreen(),
    ),
    GoRoute(
      path: '/splashscreen',
      builder: (context, state) => SplashScreenWidget(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/homepage',
      builder: (context, state) => Homescreen(),
    ),
    GoRoute(
      path: '/profilepage',
      builder: (context, state) {
        final memberData =
            state.extra as Map<String, dynamic>?; // Allow nullable
        return ProfilePage(memberData: memberData);
      },
    ),

    GoRoute(
      path: '/addreferalpage',
      builder: (context, state) => ReferralPage(),
    ),
    GoRoute(
      path: '/thankyounote',
      builder: (context, state) => ThankYouNotePage(),
    ),
    GoRoute(
      path: '/onetoone',
      builder: (context, state) => OneToOneSlipPage(),
    ),
    GoRoute(
      path: '/visitors',
      builder: (context, state) => VisitorFormPage(),
    ),
    GoRoute(
      path: '/referralview',
      builder: (context, state) {
        final referrals = state.extra as List<dynamic>;
        return ReferralDetailsPage(referrals: referrals);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => NotificationsScreen(),
    ),
    GoRoute(
      path: '/addtestimonials',
      builder: (context, state) => TestimonialSlipPage(),
    ),

    GoRoute(
      path: '/viewtestimonials',
      builder: (context, state) {
        final testimonialList = state.extra as List<dynamic>;
        return Testimonialsviewpage(testimonials: testimonialList);
      },
    ),
    GoRoute(
      path: '/thankyouview',
      builder: (context, state) {
        final data = state.extra as List<dynamic>? ?? [];
        return Thankyouviewpage(givenNotes: data);
      },
    ),

    GoRoute(
      path: '/referralDetailGiven',
      builder: (context, state) {
        final referral = state.extra as Map<String, dynamic>;
        return GivenReferralSlipPage(referral: referral);
      },
    ),

    // Inside your GoRouter routes list:
    GoRoute(
      path: '/referralDetailReceived',
      name: 'referralDetailReceived',
      builder: (context, state) {
        final referral = state.extra as Map<String, dynamic>;
        return ReceivedreferralSlip(referral: referral);
      },
    ),

    GoRoute(
      path: '/Recivedthankyou',
      builder: (context, state) {
        final item = state.extra as Map<String, dynamic>;
        return RecivedthankyouPage(data: item);
      },
    ),
    GoRoute(
      path: '/Giventhankyou',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return GiventhankyouPage(note: data);
      },
    ),
    GoRoute(
      path: '/GivenTestimonials',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return Giventestimonialspage(data: data);
      },
    ),

    GoRoute(
      path: '/Recivedtestimonial',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return Recivedtestimonialspage(data: data);
      },
    ),

    GoRoute(
      path: '/Givenonetoonepage',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return Givenonetoonepage(data: data);
      },
    ),

    GoRoute(
      path: '/ChapterDetails',
      builder: (context, state) => MyChapterPage(),
    ),
    GoRoute(
      path: '/networkerror',
      builder: (context, state) => Networkerror(),
    ),
    GoRoute(
      path: '/meeting',
      builder: (context, state) => MeetingDetailsPage(),
    ),
    GoRoute(
      path: '/viewone',
      builder: (context, state) {
        final oneToOneList = state.extra as List<dynamic>? ?? [];
        return onetooneviewpage(oneToOneList: oneToOneList);
      },
    ),

    GoRoute(
      path: '/Chaptermember',
      name: 'chapterDetails',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is MemberModel) {
          return ChapterDetails(member: extra);
        } else if (extra is othersMemberModel) {
          // ✅ Convert othersMemberModel to MemberModel including profileImageUrl
          final converted = MemberModel(
              id: extra.id,
              name: extra.name,
              company: extra.company,
              phone: extra.phone,
              role: extra.role,
              website: extra.website,
              chapterName: extra.chapterName,
              businessDescription: extra.businessDescription,
              email: extra.email,
              address: extra.address,
              profileImageUrl: extra.profileImageUrl, // ✅ include this line
              category: extra.category);
          return ChapterDetails(member: converted);
        } else {
          // Fallback if type is unknown
          return const Scaffold(
            body: Center(child: Text('Invalid member data')),
          );
        }
      },
    ),

    GoRoute(
      path: '/ViewOthers',
      builder: (context, state) => MemberListPage(),
    ),
    GoRoute(
      path: '/OthersOneToOnesPage',
      builder: (context, state) {
        final othersList = state.extra as List<dynamic>;

        return OthersOneToOnesPage(
          othersList: othersList,
        );
      },
    ),

    GoRoute(
      path: '/QRscanner',
      builder: (context, state) => QRScanPage(),
    ),
    GoRoute(
      path: '/AttendanceSuccess',
      builder: (context, state) => AttendanceSuccessPage(),
    ),
    GoRoute(
      path: '/AttendanceFailure',
      builder: (context, state) => AttendanceFailurePage(),
    ),
    GoRoute(
      path: '/membershipdetails',
      builder: (context, state) => MembershipDetailsPage(),
    ),

    GoRoute(
      path: '/Otherschapter/:chapterId',
      builder: (context, state) {
        final chapterId = state.pathParameters['chapterId']!;
        final chapterName = state.uri.queryParameters['name'] ?? '';
        return OtherChapterPage(
          chapterId: chapterId,
          chapterName: chapterName,
        );
      },
    ),

    GoRoute(
      path: '/visitorsview',
      builder: (context, state) {
        final List<dynamic> visitors = state.extra as List<dynamic>;
        return VisitorsViewpage(visitors: visitors);
      },
    ),

    GoRoute(
      path: '/visiteddetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final visitor = extra['visitor'] as Map<String, dynamic>? ?? {};
        final hideSensitiveFields = extra['hideSensitiveFields'] ?? false;

        return VisitorDetailsScreen(
          visitor: visitor,
          hideSensitiveFields: hideSensitiveFields,
        );
      },
    ),

    GoRoute(
      path: '/Event',
      builder: (context, state) => UpcomingEventsPage(),
    ),
    GoRoute(
      path: '/Registration',
      builder: (context, state) => PaymentScreen(),
    ),
    GoRoute(
      path: '/token',
      builder: (context, state) => TokenValidityPage(),
    ),
    GoRoute(
      path: '/OthersTestimonial',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OthersTestimonialsViewPage(
          memberName: extra['memberName'],
          memberId: extra['memberId'],
        );
      },
    ),

    GoRoute(
      path: '/Othersreferral',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OtherReferralViewPage(
          memberId: extra['memberId'],
          memberName: extra['memberName'],
        );
      },
    ),

    GoRoute(
      path: '/allvisitors',
      builder: (context, state) {
        final extraData = state.extra;

        // 🔒 Safe type cast
        final List<Map<String, dynamic>> allVisitors =
            (extraData as List).map((e) => e as Map<String, dynamic>).toList();

        return AllVisitorsViewpage(allVisitors: allVisitors);
      },
    ),
    GoRoute(
      path: '/Othersvisitors',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OthersVisitorsPage(
          memberId: extra['memberId'],
          memberName: extra['memberName'],
        );
      },
    ),
    GoRoute(
      path: '/Editprofile',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;

        return ProfileFormPage(
          firstName: data?['firstName'] ?? '',
          lastName: data?['lastName'] ?? '',
          companyName: data?['companyName'] ?? '',
          profileImageUrl: data?['profileImageUrl'],
        );
      },
    ),
  ],
);
