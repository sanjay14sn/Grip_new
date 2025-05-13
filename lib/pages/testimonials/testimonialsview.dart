import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class Testimonialsviewpage extends StatefulWidget {
  const Testimonialsviewpage({super.key});

  @override
  State<Testimonialsviewpage> createState() => _ReferralDetailsPageState();
}

class _ReferralDetailsPageState extends State<Testimonialsviewpage> {
  bool isReceivedSelected = false;

  final List<Map<String, String>> receivedReferrals = [
    {
      'name': 'Paul Mauray',
      'date': '12 Nov 2024',
      'image': 'assets/images/profile1.jpg'
    },
    {
      'name': 'Dinesh',
      'date': '12 Nov 2024',
      'image': 'assets/images/profile2.jpg'
    },
    {
      'name': 'Amaran',
      'date': '15 Nov 2024',
      'image': 'assets/images/profile1.jpg'
    },
    {
      'name': 'Babu',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile3.jpg'
    },
    {
      'name': 'Mani',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile4.jpg'
    },
  ];

  final List<Map<String, String>> givenReferrals = [
    {
      'name': 'Suresh Kumar',
      'date': '10 Nov 2024',
      'image': 'assets/images/profile1.jpg'
    },
    {
      'name': 'Priya Dharshini',
      'date': '11 Nov 2024',
      'image': 'assets/images/profile2.jpg'
    },
    {
      'name': 'John Moses',
      'date': '12 Nov 2024',
      'image': 'assets/images/profile3.jpg'
    },
    {
      'name': 'Radha',
      'date': '13 Nov 2024',
      'image': 'assets/images/profile4.jpg'
    },
    {
      'name': 'Ajay',
      'date': '14 Nov 2024',
      'image': 'assets/images/profile1.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),

                  // Filter Icon
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Dismiss",
                        barrierColor: Colors.transparent,
                        transitionDuration: Duration(milliseconds: 200),
                        pageBuilder: (_, __, ___) {
                          return Stack(
                            children: [
                              Positioned(
                                top: 60,
                                right: 16,
                                child: Material(
                                  color: Colors.transparent,
                                  child: FilterDialog(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.filter_alt_outlined,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),

               Row(
                children: [
                  Text('Testimonials Details', style: TTextStyles.ReferralSlip),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/fluent_person-feedback-16-filled.png', // Replace with your actual image path
                    width: 34,
                    height: 34,
                  )
                ],
              ),


              SizedBox(height: 1.5.h),

              // Category toggle
              Text('Category:', style: TTextStyles.Category),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // GIVEN button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = false),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                !isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Given',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // RECEIVED button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = true),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Received',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Referral List using ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: isReceivedSelected
                      ? receivedReferrals.length
                      : givenReferrals.length,
                  itemBuilder: (context, index) {
                    final item = isReceivedSelected
                        ? receivedReferrals[index]
                        : givenReferrals[index];
                    return referralTile(item['name']!, item['date']!,
                        item['image']!, isReceivedSelected);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tile Widget with different routes based on tab
  Widget referralTile(
      String name, String date, String imagePath, bool isReceived) {
    return GestureDetector(
      onTap: () {
        if (isReceived) {
          context.push('/ReceivedTestimonials'); // received route
        } else {
          context.push('/GivenTestimonials'); // given route
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 2.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
