import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class onetooneviewpage extends StatefulWidget {
  final List<dynamic> oneToOneList;

  const onetooneviewpage({super.key, required this.oneToOneList});

  @override
  State<onetooneviewpage> createState() => _ReferralDetailsPageState();
}

class _ReferralDetailsPageState extends State<onetooneviewpage> {
  bool isReceivedSelected = false;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> oneToOneData = widget.oneToOneList;
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
                  Text('one to ones', style: TTextStyles.ReferralSlip),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/testimonials.png', // Replace with your actual image path
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
                            'My One to Ones',
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

// RECEIVED button (navigates instead of toggling state)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push('/ViewOthers');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'View Others',
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
                  itemCount: oneToOneData.length,
                  itemBuilder: (context, index) {
                    final item = oneToOneData[index];

                    final name = item['toMember']?['personalDetails']
                            ?['firstName'] ??
                        'Unknown';
                    final rawDate = item['date'];
                    final date = rawDate != null
                        ? DateFormat('dd-MM-yyyy')
                            .format(DateTime.parse(rawDate))
                        : '';
                    final image = 'assets/images/profile1.jpg'; // placeholder

                    return referralTile(
                        item, name, date, image, isReceivedSelected);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget referralTile(
    Map<String, dynamic> item,
    String name,
    String date,
    String imagePath,
    bool isReceivedSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (isReceivedSelected) {
          context.push('/ViewOthers');
        } else {
          context.push('/Givenonetoonepage', extra: item);
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
