import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/pages/Eventpage.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/components/download.dart' as FileDownloader;

class Givenonetoonepage extends StatefulWidget {
  final Map<String, dynamic> data;

  const Givenonetoonepage({super.key, required this.data});

  @override
  State<Givenonetoonepage> createState() => _Givenonetoonepage();
}

class _Givenonetoonepage extends State<Givenonetoonepage> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final toMember = widget.data['toMember'] as Map<String, dynamic>? ?? {};
    final personalDetails =
        toMember['personalDetails'] as Map<String, dynamic>? ?? {};
    final fullName =
        "${personalDetails['firstName'] ?? ''} ${personalDetails['lastName'] ?? ''}"
            .trim();
    final companyName = toMember['companyName'] ?? 'No Company';

    final images = widget.data['images'] as List? ?? [];
    final hasImages = images.isNotEmpty;

    final currentImage = hasImages ? images[currentImageIndex] : null;
    final imageName = currentImage?['originalName'] ??
        currentImage?['docName'] ??
        'No Document';
    final docPath = currentImage?['docPath'] ?? '';
    final docName = currentImage?['docName'] ?? '';

    final imageUrl = (hasImages && docPath.isNotEmpty && docName.isNotEmpty)
        ? "${UrlService.imageBaseUrl}/$docPath/$docName"
        : null;

    final place = widget.data['whereDidYouMeet'] ?? 'No place specified';
    final address = widget.data['address'] ?? 'No location';
    final dateStr = widget.data['date'];
    final formattedDate = dateStr != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(dateStr))
        : 'No date';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔙 Back & Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 7.w),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6221A),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Text(
                          'ONE TO ONE SLIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 2.h),

              /// 🧾 Card
              SizedBox(
                height: 70.h,
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

                        /// 👤 Profile
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person,
                                  size: 24, color: Colors.grey[500]),
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName.isNotEmpty ? fullName : 'No Name',
                                  style: TTextStyles.refname,
                                ),
                                Text(companyName,
                                    style: TTextStyles.Rivenrefsmall),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),

                        const Text(
                          "Image:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        /// 📄 Document Viewer
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
                                /// Header Row
                                Container(
                                  height: 2.5.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          imageName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (hasImages &&
                                              currentImageIndex > 0)
                                            GestureDetector(
                                              onTap: () => setState(
                                                  () => currentImageIndex--),
                                              child: _buildIconButton('<'),
                                            ),
                                          SizedBox(width: 1.w),
                                          if (hasImages &&
                                              currentImageIndex <
                                                  images.length - 1)
                                            GestureDetector(
                                              onTap: () => setState(
                                                  () => currentImageIndex++),
                                              child: _buildIconButton('>'),
                                            ),
                                          SizedBox(width: 2.w),
                                          Icon(Icons.download,
                                              size: 14.sp, color: Colors.blue),
                                          SizedBox(width: 1.w),
                                          GestureDetector(
                                            onTap: () {
                                              if (imageUrl != null &&
                                                  imageUrl.isNotEmpty) {
                                                final fileName =
                                                    imageUrl.split('/').last;
                                                FileDownloader.FileDownloader
                                                    .downloadImage(
                                                  url: imageUrl,
                                                  fileName: fileName,
                                                  context: context,
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                SizedBox(width: 1.w),
                                                Text(
                                                  'Download',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// 🖼️ Image Area
                                Expanded(
                                  child: imageUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          progressIndicatorBuilder:
                                              (context, url, progress) {
                                            final percent =
                                                progress.progress ?? 0.0;
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    '${(percent * 100).toStringAsFixed(0)}%'),
                                                SizedBox(height: 8),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  child:
                                                      LinearProgressIndicator(
                                                          value: percent),
                                                ),
                                              ],
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                                  child: Text(
                                                      "❌ Image load failed")),
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: const Text("No Image"),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),

                        /// 🏠 Place
                        Text('Place Met:', style: TTextStyles.Rivenrefsmall),
                        Text(place, style: TTextStyles.reftext),
                        SizedBox(height: 1.5.h),

                        /// 📅 Date
                        Text('Date:', style: TTextStyles.Rivenrefsmall),
                        Text(formattedDate, style: TTextStyles.reftext),
                        SizedBox(height: 1.5.h),

                        /// 📌 Location
                        Text('Location:', style: TTextStyles.Rivenrefsmall),
                        Text(address, style: TTextStyles.reftext),
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

  Widget _buildIconButton(String label) {
    return Container(
      width: 7.w,
      height: 2.5.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
