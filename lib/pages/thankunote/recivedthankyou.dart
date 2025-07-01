import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/backend/api-requests/imageurl.dart'; // for UrlService

class RecivedthankyouPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const RecivedthankyouPage({super.key, required this.data});

  String? buildImageUrl(Map<String, dynamic>? image) {
    if (image == null) return null;
    final docPath = image['docPath'];
    final docName = image['docName'];
    if (docPath == null || docName == null) return null;
    return "${UrlService.imageBaseUrl}/$docPath/$docName";
  }

  @override
  Widget build(BuildContext context) {
    final from = data['fromMember']?['personalDetails'];
    final name = "${from?['firstName'] ?? ''} ${from?['lastName'] ?? ''}".trim();
    final company = from?['companyName'] ?? 'Company Name';
    final amount = data['amount']?.toString() ?? '0';
    final comments = data['comments'] ?? 'No comments provided';

    final profileImageMap = data['fromMember']?['personalDetails']?['profileImage'];
    final imageUrl = buildImageUrl(profileImageMap);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
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

              SizedBox(height: 1.5.h),

              // Header
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6221A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'RECEIVED THANK YOU NOTE SLIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Main Content
              Expanded(
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
                        Text("From:", style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage('assets/images/person.png') as ImageProvider,
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name.isNotEmpty ? name : 'No Name', style: TTextStyles.refname),
                                Text(company, style: TTextStyles.Rivenrefsmall),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text('Amount:', style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.currency_rupee, color: const Color(0xFFC6221A), size: 20.sp),
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
                        SizedBox(height: 0.5.h),
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
