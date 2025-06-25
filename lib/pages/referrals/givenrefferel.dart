import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class GivenReferralSlipPage extends StatelessWidget {
  final Map<String, dynamic> referral;

  const GivenReferralSlipPage({super.key, required this.referral});

  @override
  Widget build(BuildContext context) {
    final detail = referral['referalDetail'] ?? {};
    final status = referral['referalStatus'] ?? 'Not Available';
    final name = detail['name'] ?? 'No Name';
    final category = detail['category'] ?? 'N/A';
    final mobile = detail['mobileNumber'] ?? 'N/A';
    final comments = detail['comments'] ?? 'No comments';
    final address = detail['address'] ?? 'No address';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back & Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6221A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'GIVEN REFERRAL SLIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // 📝 Main Content Card
              SizedBox(
                height: 67.h,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name:", style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage('assets/images/person.png'),
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: TTextStyles.refname),
                               // Text("", style: TTextStyles.Rivenrefsmall),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text('Referral Status:', style: TTextStyles.Rivenrefsmall),
                        Text(status, style: TTextStyles.reftext),
                        SizedBox(height: 2.h),
                        Text('Contact Details:', style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F2F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Mobile:\n'),
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.call,
                                          size: 16,
                                          color: Color(0xFFC6221A),
                                        ),
                                      ),
                                      TextSpan(
                                        text: mobile,
                                        style: TTextStyles.Refcontact,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F2F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFFC6221A), size: 16),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(address, style: TTextStyles.Refcontact),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                     //   Text('Category:', style: TTextStyles.Rivenrefsmall),
                     //   Text(category, style: TTextStyles.reftext),
                        SizedBox(height: 2.h),
                        Text('Comments:', style: TTextStyles.Rivenrefsmall),
                        Text(comments, style: TTextStyles.reftext),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
