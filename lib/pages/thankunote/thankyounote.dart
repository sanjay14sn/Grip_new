import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/Dotloader.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

import '../../backend/api-requests/no_auth_api.dart'
    show PublicRoutesApiService;

class ThankYouNotePage extends StatefulWidget {
  const ThankYouNotePage({super.key});

  @override
  State<ThankYouNotePage> createState() => _ThankYouNotePageState();
}

class _ThankYouNotePageState extends State<ThankYouNotePage> {
  String? selectedPerson;
  bool isSubmitting = false;

  String? selectedPersonId;
  final List<String> personList = ['Person A', 'Person B', 'Person C'];
  final Color customRed = const Color(0xFFC6221A);
  bool showMyChapter = true;
  String? selectedPersonIdFromNumber;

  // Controllers for API integration
  final TextEditingController associateMobileController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    associateMobileController.dispose();
    amountController.dispose();
    commentsController.dispose();
    super.dispose();
  }

  void submitForm() async {
    if (isSubmitting) {
      return;
    }

    setState(() => isSubmitting = true); // Start loader

    final toMember =
        showMyChapter ? selectedPersonId : selectedPersonIdFromNumber;
    final amount = amountController.text.trim();
    final comments = commentsController.text.trim();

    if (toMember == null || toMember.isEmpty) {
      ToastUtil.showToast(
          context, "Please select a member or enter associate number");
      setState(() => isSubmitting = false);
      return;
    }

    if (amount.isEmpty) {
      ToastUtil.showToast(context, "Amount is required");
      setState(() => isSubmitting = false);
      return;
    }

    if (!RegExp(r'^\d{1,20}$').hasMatch(amount)) {
      ToastUtil.showToast(context, "Amount must be numeric and max 20 digits");
      setState(() => isSubmitting = false);
      return;
    }

    if (comments.isEmpty) {
      ToastUtil.showToast(context, "Comments is required");
      setState(() => isSubmitting = false);
      return;
    }

    if (comments.length > 250) {
      ToastUtil.showToast(context, "Comments must be under 150 characters");
      setState(() => isSubmitting = false);
      return;
    }

    final double parsedAmount = double.tryParse(amount) ?? 0;

    final response = await PublicRoutesApiService.submitThankYouNoteSlip(
      toMember: toMember,
      amount: parsedAmount,
      comments: comments,
    );

    if (response.isSuccess) {
      ToastUtil.showToast(context, "Thank You Note submitted successfully");
      Navigator.pop(context, true); // refresh home
    } else {}

    setState(() => isSubmitting = false); // Stop loader
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
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

                        Row(
                          children: [
                            Image.asset(
                              'assets/images/handshake.png', // Replace with your icon
                              height: 44.sp,
                              width: 44.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text('Thank U Note Slip',
                                style: TTextStyles.ReferralSlip),
                          ],
                        ),

                        SizedBox(height: 1.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.w), // Horizontal padding
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.5.h),
                                          decoration: BoxDecoration(
                                            gradient: showMyChapter
                                                ? Tcolors.red_button
                                                : null,
                                            color: showMyChapter
                                                ? null
                                                : Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.horizontal(
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.5.h),
                                          decoration: BoxDecoration(
                                            gradient: !showMyChapter
                                                ? Tcolors.red_button
                                                : null,
                                            color: !showMyChapter
                                                ? null
                                                : Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.horizontal(
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
                                  onSelect:
                                      (name, uid, chapterId, chapterName) {
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

                        SizedBox(height: 2.h),

                        // Amount Input with ₹ icon
                        Container(
                          height: 6.5.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: double.infinity,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  color: Tcolors.smalll_button,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(2.w),
                                    bottomLeft: Radius.circular(2.w),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.currency_rupee,
                                      color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.w),
                                  child: TextField(
                                    controller: amountController,
                                    // maxLength: 20,
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                      border: InputBorder.none,
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),

                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Comments Field
                        Container(
                            width: double.infinity,
                            height: 15.h,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: TextField(
                              controller: commentsController,
                              //maxLength: 150,
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Comments",
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250),
                              ],
                            )),

                        SizedBox(height: 4.h),

                        // Submit Button with gradient
                        SizedBox(
                          width: double.infinity,
                          height: 6.5.h,
                          child: ElevatedButton(
                            onPressed: submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: Tcolors.red_button,
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Center(
                                child: isSubmitting
                                    ? const DotLoader(
                                        color: Colors.white,
                                        size: 8,
                                        dotCount: 4,
                                      )
                                    : Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
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
            },
          ),
        ),
      );
    });
  }
}
