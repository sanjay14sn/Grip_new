import 'dart:io';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/Dotloader.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class TestimonialSlipPage extends StatefulWidget {
  @override
  State<TestimonialSlipPage> createState() => _TestimonialSlipPageState();
}

class _TestimonialSlipPageState extends State<TestimonialSlipPage> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController associateMobileController =
      TextEditingController();

  bool showMyChapter = true;

  String? selectedPersonId; // For MY CHAPTER
  String? selectedPersonIdFromNumber; // For OTHER CHAPTER
  bool isSubmitting = false;

  List<File> pickedImages = [];

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
        ],
      );

      if (result != null) {
        setState(() {
          pickedImages = result.paths
              .whereType<String>()
              .map((path) => File(path))
              .toList();
        });
      }
    } catch (e) {}
  }

  Future<void> _submitTestimonial() async {
    if (isSubmitting) return;

    // setState(() => isSubmitting = true);
    final toMember =
        showMyChapter ? selectedPersonId : selectedPersonIdFromNumber;
    final comment = commentController.text.trim();

    if (toMember == null || toMember.isEmpty) {
      ToastUtil.showToast(
          context, "Please select a member or enter associate number");
      return;
    }

    if (comment.isEmpty) {
      ToastUtil.showToast(context, "Comments are required");
      return;
    }

    if (comment.length > 150) {
      ToastUtil.showToast(context, "Comments must be under 150 characters");
      return;
    }

    if (pickedImages.isEmpty) {
      ToastUtil.showToast(context, "Please upload at least one document");
      return;
    }

    setState(() => isSubmitting = true);
    final response = await PublicRoutesApiService.submitTestimonialSlip(
      toMember: toMember,
      comments: comment,
      imageFiles: pickedImages,
    );

    if (response.isSuccess) {
      ToastUtil.showToast(context, "✅ Testimonial submitted successfully");
      Navigator.pop(context, true);
    } else {}
    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final blueUploadColor = const Color(0xFF51A6C5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
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
              SizedBox(height: 3.h),
              Text('Testimonial Slip', style: TTextStyles.ReferralSlip),
              SizedBox(height: 2.h),

              // Toggle Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildTab("MY CHAPTER", true),
                    _buildTab("OTHER CHAPTER", false),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // Conditional Inputs
              showMyChapter
                  ? MemberDropdown(
                      onSelect: (name, uid, chapterId, chapterName) {
                        setState(() {
                          selectedPersonId = uid;
                        });
                      },
                    )
                  : CustomInputField(
                      label: 'Enter Associate Mobile Number',
                      controller: associateMobileController,
                      enableContactPicker: true,
                      onUidFetched: (uid) {
                        selectedPersonIdFromNumber = uid;
                      },
                      isRequired: true,
                    ),

              SizedBox(height: 3.h),

              // File Upload
              DottedBorder(
                color: blueUploadColor,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: InkWell(
                  onTap: _pickFiles,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    decoration: BoxDecoration(
                      color: blueUploadColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDashedUploadIcon(),
                        SizedBox(height: 1.h),
                        Text(
                          'Upload Images',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (pickedImages.isNotEmpty) ...[
                SizedBox(height: 1.h),
                Text("Uploaded Images:", style: TextStyle(fontSize: 14.sp)),
                ...pickedImages.asMap().entries.map((entry) {
                  return ListTile(
                    title: Text(entry.value.path.split('/').last,
                        style: TextStyle(fontSize: 12.sp)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => pickedImages.removeAt(entry.key));
                      },
                    ),
                  );
                }),
              ],
              SizedBox(height: 3.h),

              // Comment Box
              Container(
                height: 10.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: commentController,
                  maxLines: null,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Comments'),
                ),
              ),
              SizedBox(height: 4.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: Tcolors.red_button,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitTestimonial,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          Colors.transparent, // Transparent so gradient shows
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: isSubmitting
                        ? const DotLoader()
                        : Text(
                            "Submit",
                            style:
                                TextStyle(fontSize: 13.sp, color: Colors.white),
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

  Widget _buildTab(String label, bool isMyChapter) {
    final isSelected = showMyChapter == isMyChapter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          showMyChapter = isMyChapter;
          selectedPersonId = null;
          selectedPersonIdFromNumber = null;
          associateMobileController.clear();
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            gradient: isSelected ? Tcolors.red_button : null,
            borderRadius: BorderRadius.horizontal(
              left: isMyChapter ? const Radius.circular(8) : Radius.zero,
              right: !isMyChapter ? const Radius.circular(8) : Radius.zero,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashedUploadIcon() {
    return SizedBox(
      width: 53,
      height: 53,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DashedCircle(
            dashes: 20,
            gapSize: 3,
            color: Colors.white,
            child: const SizedBox(width: 53, height: 53),
          ),
          Container(
            width: 43,
            height: 43,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.add, size: 24, color: Color(0xFF50A6C5)),
          ),
        ],
      ),
    );
  }
}
