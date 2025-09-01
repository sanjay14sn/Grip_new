
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ReferralCarousel extends StatefulWidget {
  const ReferralCarousel({super.key});

  @override
  State<ReferralCarousel> createState() => _ReferralCarouselState();
}

class _ReferralCarouselState extends State<ReferralCarousel> {
  List<Map<String, dynamic>> referrals = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  static const specialChapterId = '6878eb1a60ef1e65cb84aa90';
  String? currentChapterId;

  final allowedKeys = ['referralSlips', 'thankYouSlips', 'visitors'];

  final List<Map<String, dynamic>> setA = [
    {
      "name": "MOHAMED UMAR",
      "category": "SOFTWARE DEVELOPER",
      "title": "referralSlips",
      "image": "assets/images/umar.png",
    },
    {
      "name": "MANO N",
      "category": "INTERIOR DESIGNER",
      "title": "thankYouSlips",
      "image": "assets/images/mano .png",
    },
    {
      "name": "MATHIARASU M",
      "category": "FIRE & SAFETY",
      "title": "visitors",
      "image": "assets/images/sliderlast.png",
    },
  ];

  final List<Map<String, dynamic>> setB = [
    {
      "name": "R.VARADARAJ",
      "category": "CO-FOUNDER & COO",
      "title": "referralSlips",
      "image": "assets/images/varadha.png",
    },
    {
      "name": "R.PRATHEEP GANDHI",
      "category": "FOUNDER & CEO",
      "title": "thankYouSlips",
      "image": "assets/images/gandhi.png",
    },
    {
      "name": "PUGALENTHI PALANIVELU",
      "category": "Co-FOUNDER & CFO",
      "title": "visitors",
      "image": "assets/images/pugal.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchTopPerformers();
  }

Future<void> fetchTopPerformers() async {
  final response = await PublicRoutesApiService.fetchTopPerformersMonthly();

  if (response.isSuccess && response.data != null) {
    final data = response.data!;
    List<Map<String, dynamic>> formatted = [];

    data.forEach((key, value) {
      if (allowedKeys.contains(key)) {
        final performer = value['topPerformer'];
        if (performer != null) {
          formatted.add({
            "name": performer['name'] ?? '',
            "category": performer['categoryRepresented'] ?? '',
            "title": key,
            "image":
                '${UrlService.imageBaseUrl}/${performer["profileImage"]["docPath"]}/${performer["profileImage"]["docName"]}',
          });
        }
      }
    });

    setState(() {
      referrals = formatted;
      _isLoading = false;
    });
  } else {
    // ✅ Always show setA if API fails
    setState(() {
      referrals = setA;
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
    return buildShimmer();
  }

  if (referrals.isEmpty) {
    // ✅ Always use setA as fallback
    referrals = setA;
  }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 23.h,
            viewportFraction: 1.1,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: referrals.map((referral) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Tcolors.smalll_button,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: referral["image"].toString().startsWith('http')
                          ? Image.network(
                              referral["image"],
                              width: 24.w,
                              height: 17.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset("assets/images/dummyslider.jpg"),
                            )
                          : Image.asset(
                              referral["image"],
                              width: 24.w,
                              height: 17.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/topreff.png',
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            formatTitle(referral["title"]),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    referral["name"] ?? '',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Text(
                                    referral["category"] ?? '',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: referrals.asMap().entries.map((entry) {
            return Container(
              width: 3.w,
              height: 3.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Tcolors.smalll_button
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 3,
          options: CarouselOptions(
            height: 23.h,
            viewportFraction: 1.1,
            enableInfiniteScroll: false,
          ),
          itemBuilder: (context, index, realIdx) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 23.h,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 17.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              width: 60.w,
                              height: 2.5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                            ),
                            SizedBox(height: 1.2.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 2.h,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 15.w,
                                    height: 2.h,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 3.w,
              height: 3.w,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }

  String formatTitle(String rawKey) {
    switch (rawKey) {
      case 'referralSlips':
        return "Maximum Referrals Contributed";
      case 'thankYouSlips':
        return "Maximum Business Contributed";
      case 'visitors':
        return "Maximum Visitors Invited";
      default:
        return rawKey;
    }
  }
}
