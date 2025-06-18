import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class ReferralCarousel extends StatefulWidget {
  const ReferralCarousel({super.key});

  @override
  State<ReferralCarousel> createState() => _ReferralCarouselState();
}

class _ReferralCarouselState extends State<ReferralCarousel> {
  final List<Map<String, String>> referrals = [
    {"name": "Mr. Suthik", "image": "assets/images/dummyslider.jpg"},
    {"name": "Ms. Priya", "image": "assets/images/dummyslider.jpg"},
    {"name": "Mr. Arjun", "image": "assets/images/dummyslider.jpg"},
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 20.h,

            viewportFraction: 1.1, // <- Full width, no side visibility
            enableInfiniteScroll: true,
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
                      child: Image.asset(
                        referral["image"]!,
                        width: 24.w,
                        height: 17.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 17.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Changed here
                          children: [
                            Image.asset(
                              'assets/images/topreff.png', // replace with your image path
                              width: 15.w,
                              height: 15.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              "TOP REFERRAL OF \n THE MONTH",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign
                                  .center, // Also add this for multi-line center
                            ),
                            SizedBox(height: 0.8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Text(
                                referral["name"]!,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign
                                    .center, // Center text inside container too
                              ),
                            ),
                          ],
                        ),
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
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 3.w,
                height: 3.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Tcolors.smalll_button
                      : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
