import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class GiventhankyouPage extends StatelessWidget {
  final Map<String, dynamic> note;

  const GiventhankyouPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    // ✅ Safely access nested fields from note
    final toFirstName =
        note['toMember']?['personalDetails']?['firstName'] ?? '';
    final toLastName = note['toMember']?['personalDetails']?['lastName'] ?? '';
    final toName = "$toFirstName $toLastName".trim();
    final toCompany = note['toMember']?['company'] ?? 'No Company';
    final amount = note['amount']?.toString() ?? '0';
    final comment = note['comments'] ?? 'No Comments';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              Row(
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

              // 🏷️ Header
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6221A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'GIVEN THANK YOU NOTE SLIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // 📄 Card with Details
              SizedBox(
                height: 67.h,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("To:", style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  AssetImage('assets/images/person.png'),
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(toName.isNotEmpty ? toName : 'No Name',
                                    style: TTextStyles.refname),
                                Text(toCompany,
                                    style: TTextStyles.Rivenrefsmall),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text('Amount:', style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.currency_rupee,
                                  color: const Color(0xFFC6221A), size: 20.sp),
                              SizedBox(width: 1.w),
                              Text(
                                amount,
                                style: TextStyle(
                                  color: const Color(0xFFC6221A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text('Comments:', style: TTextStyles.Rivenrefsmall),
                        Text(comment, style: TTextStyles.reftext),
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
