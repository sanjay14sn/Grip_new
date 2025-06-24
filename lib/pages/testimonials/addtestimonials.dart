import 'dart:io';

import 'package:dashed_circle/dashed_circle.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';

import 'package:grip/components/Associate_number.dart';
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
  final Color customRed = const Color(0xFFC83837);
  final Color blueUploadColor = const Color(0xFF51A6C5);
  final BorderRadius boxRadius = BorderRadius.circular(12.0);

  final TextEditingController commentController = TextEditingController();
  final TextEditingController associateMobileController =
      TextEditingController();
  String? selectedPersonIdFromNumber;
  String? selectedPersonId;
  String? selectedPerson;
  List<File> pickedImages = [];
  bool showMyChapter = true;

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        pickedImages =
            result.paths.whereType<String>().map((e) => File(e)).toList();
      });
    }
  }

  Future<void> _submitTestimonial() async {
    final toMember =
        showMyChapter ? selectedPersonId : selectedPersonIdFromNumber;

    if (toMember == null || commentController.text.isEmpty) {
      ToastUtil.showToast(context,"Please select a member and write comments");
      return;
    }

    final response = await PublicRoutesApiService.submitTestimonialSlip(
      toMember: toMember,
      comments: commentController.text,
      imageFiles: pickedImages,
    );

    if (response.isSuccess) {
      ToastUtil.showToast(context,"✅ Testimonial submitted successfully");
      Navigator.pop(context, true); // ✅ Return true
    } else {
      ToastUtil.showToast(context,"❌ Failed: ${response.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  SizedBox(width: 2.w),
                  Text('Testimonial Slip', style: TTextStyles.ReferralSlip),
                ],
              ),
              SizedBox(height: 2.h),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.w), // Horizontal padding
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade300,
                      ),
                      child: Row(
                        children: [
                          /// MY CHAPTER TAB
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                showMyChapter = true;
                                associateMobileController.clear();
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  gradient:
                                      showMyChapter ? Tcolors.red_button : null,
                                  color:
                                      showMyChapter ? null : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "MY CHAPTER",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: showMyChapter
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// OTHER CHAPTER TAB
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                showMyChapter = false;
                                selectedPerson = null;
                                selectedPersonId = null;
                              }),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  gradient: !showMyChapter
                                      ? Tcolors.red_button
                                      : null,
                                  color: !showMyChapter
                                      ? null
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "OTHER CHAPTER",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: !showMyChapter
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// Show input or dropdown based on selection
                    if (!showMyChapter) ...[
                      CustomInputField(
                        label: 'Enter Associate Mobile Number',
                        isRequired: false,
                        controller: associateMobileController,
                        enableContactPicker: true,
                        onUidFetched: (uid) {
                          selectedPersonIdFromNumber = uid;
                        },
                      ),
                    ] else ...[
                      MemberDropdown(
                        onSelect: (name, uid, chapterId, chapterName) {
                          setState(() {
                            selectedPerson = name;
                            selectedPersonId = uid;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Center(
                child: Column(
                  children: [
                    DottedBorder(
                      color: blueUploadColor,
                      dashPattern: [6, 3],
                      strokeWidth: 1.5,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      child: InkWell(
                        onTap: _pickFiles,
                        child: Container(
                          width: 90.w,
                          height: 12.h,
                          color: blueUploadColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 53,
                                height: 53,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    DashedCircle(
                                      dashes: 20,
                                      gapSize: 3,
                                      color: Colors.white,
                                      child: const SizedBox(
                                        width: 53,
                                        height: 53,
                                      ),
                                    ),
                                    Container(
                                      width: 43,
                                      height: 43,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 24,
                                          color: Color(0xFF50A6C5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Upload Documents',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                      Text(
                        "Uploaded Documents:",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      SizedBox(height: 0.5.h),
                      ...pickedImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        File file = entry.value;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            file.path.split('/').last,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                pickedImages.removeAt(index);
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                height: 12.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F9),
                  borderRadius: boxRadius,
                ),
                child: TextField(
                  controller: commentController,
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Comments',
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: double.infinity,
                height: 6.5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: Tcolors.red_button,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: _submitTestimonial,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
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
