import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class Giventestimonialspage extends StatelessWidget {
  final Map<String, dynamic> data;

  const Giventestimonialspage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final toMember = data['toMember'];
    final personalDetails = toMember['personalDetails'];
    final fullName =
        "${personalDetails['firstName']} ${personalDetails['lastName']}";
    final companyName = toMember['companyName'] ?? 'No Company';

    final comment = data['comments'] ?? '';
    final images = data['images'] as List;
    final imageName =
        images.isNotEmpty ? images[0]['originalName'] : 'No Document';
    final imageUrl = images.isNotEmpty
        ? 'https://api.grip.oceansoft.online${images[0]['docPath']}'
        : null;

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

              // 🟥 Page Title
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFC6221A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'GIVEN TESTIMONIAL SLIP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // 🧾 Main Card
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
                        Text("To:", style: TTextStyles.Rivenrefsmall),
                        SizedBox(height: 1.h),

                        // 👤 Member Info
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
                                Text(fullName, style: TTextStyles.refname),
                                Text(companyName,
                                    style: TTextStyles.Rivenrefsmall),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // 📎 Document
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Document:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 25.3.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Column(
                                  children: [
                                    // 🔼 Top Info Row
                                    Container(
                                      height: 2.53.h,
                                      width: double.infinity,
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            imageName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              _buildIconButton('<'),
                                              SizedBox(width: 1.w),
                                              _buildIconButton('>'),
                                              SizedBox(width: 2.w),
                                              Text(
                                                'Share',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Row(
                                                children: [
                                                  Icon(Icons.download,
                                                      size: 14.sp,
                                                      color: Colors.blue),
                                                  SizedBox(width: 1.w),
                                                  Text(
                                                    'Download',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 🖼️ Image Area
                                    Expanded(
                                      child: imageUrl != null
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Text("No Document"),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // 💬 Comments
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

  // 🔘 Reusable Nav Buttons (< >)
  Widget _buildIconButton(String label) {
    return Container(
      width: 7.w,
      height: 2.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
