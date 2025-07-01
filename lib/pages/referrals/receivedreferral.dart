import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ReceivedreferralSlip extends StatelessWidget {
  final Map<String, dynamic> referral;

  const ReceivedreferralSlip({super.key, required this.referral});

  // 🔍 Get profile image map
  Map<String, dynamic>? getProfileImageMap() {
    final fromMember = referral['fromMember'] as Map<String, dynamic>?;
    final personalDetails =
        fromMember?['personalDetails'] as Map<String, dynamic>?;
    return personalDetails?['profileImage'] as Map<String, dynamic>?;
  }

  // 🌐 Build image URL
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
    final referalDetail = referral['referalDetail'] ?? {};
    final status = referral['referalStatus'] ?? 'Not Available';
    final name = referalDetail['name'] ?? 'No Name';
    final mobile = referalDetail['mobileNumber'] ?? 'N/A';
    final address = referalDetail['address'] ?? 'No address';
    final category = referalDetail['category'] ?? '';
    final comments = referalDetail['comments'] ?? 'No comments';
    final from = referral['fromMember']?['personalDetails'] ?? {};
    final fromName =
        '${from['firstName'] ?? ''} ${from['lastName'] ?? ''}'.trim();

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

              /// 🔙 Back Button
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

              /// 🟥 Header
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6221A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'RECEIVED REFERRAL SLIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              /// 📋 Card Content
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
                          Text("From:", style: TTextStyles.Rivenrefsmall),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: imageUrl != null
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage(
                                            'assets/images/person.png')
                                        as ImageProvider,
                              ),
                              SizedBox(width: 3.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fromName, style: TTextStyles.refname),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          Text('Referral Status:',
                              style: TTextStyles.Rivenrefsmall),
                          Text(status, style: TTextStyles.reftext),
                          SizedBox(height: 2.h),

                          Text('Contact Details:',
                              style: TTextStyles.Rivenrefsmall),
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
                                const Icon(Icons.call,
                                    color: Color(0xFFC6221A), size: 16),
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
                                const Icon(Icons.location_on,
                                    color: Color(0xFFC6221A), size: 16),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(address,
                                      style: TTextStyles.Refcontact),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // 📝 Comments
                          Text('Comments:', style: TTextStyles.Rivenrefsmall),
                          SizedBox(height: 1.h),
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
