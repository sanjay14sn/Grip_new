import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class GivenReferralSlipPage extends StatelessWidget {
  final Map<String, dynamic> referral;

  const GivenReferralSlipPage({super.key, required this.referral});

  // 🔍 Extract profile image info
  Map<String, dynamic>? getProfileImageMap() {
    final toMember = referral['toMember'] as Map<String, dynamic>?;
    final personalDetails = toMember?['personalDetails'] as Map<String, dynamic>?;
    return personalDetails?['profileImage'] as Map<String, dynamic>?;
  }

  // 🌐 Construct profile image URL
  String? buildImageUrl(Map<String, dynamic>? imageMap) {
    final docPath = imageMap?['docPath'];
    final docName = imageMap?['docName'];

    if (docPath != null && docName != null) {
      return "${UrlService.imageBaseUrl}/$docPath/$docName";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final detail = referral['referalDetail'] ?? {};
    final status = referral['referalStatus'] ?? 'Not Available';
    final name = detail['name'] ?? 'No Name';
    final category = detail['category'] ?? 'N/A';
    final mobile = detail['mobileNumber'] ?? 'N/A';
    final comments = detail['comments'] ?? 'No comments';
    final address = detail['address'] ?? 'No address';

    final imageMap = getProfileImageMap();
    final imageUrl = buildImageUrl(imageMap);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // 🔙 Back Button & Title
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
              SizedBox(height: 1.5.h),
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

              // 📋 Main Content
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name:", style: TTextStyles.Rivenrefsmall),
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
                                  Text(name, style: TTextStyles.refname),
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

                          // 📞 Mobile
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F2F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.call, color: Color(0xFFC6221A), size: 16),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    mobile,
                                    style: TTextStyles.Refcontact,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),

                          // 📍 Address
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F2F7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFFC6221A), size: 16),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: TTextStyles.Refcontact,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // 📝 Category (optional)
                          // Text('Category:', style: TTextStyles.Rivenrefsmall),
                          // Text(category, style: TTextStyles.reftext),
                          // SizedBox(height: 2.h),

                          Text('Comments:', style: TTextStyles.Rivenrefsmall),
                          Text(comments, style: TTextStyles.reftext),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
