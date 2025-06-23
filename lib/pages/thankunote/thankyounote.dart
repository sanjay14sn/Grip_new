import 'package:flutter/material.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ThankYouNotePage extends StatefulWidget {
  const ThankYouNotePage({super.key});

  @override
  State<ThankYouNotePage> createState() => _ThankYouNotePageState();
}

class _ThankYouNotePageState extends State<ThankYouNotePage> {
  String? selectedPerson;
  String? selectedPersonId;
  final List<String> personList = ['Person A', 'Person B', 'Person C'];
  final Color customRed = const Color(0xFFC6221A);
  bool showMyChapter = true;

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

  void submitForm() {
    // Collect data for API call
    final formData = {
      'associateMobile': associateMobileController.text,
      'thankYouTo': selectedPerson,
      'amount': amountController.text,
      'comments': commentsController.text,
    };

    // TODO: Implement API call using formData
    print('Submitting form: $formData');
    // Example:
    // ApiService.submitThankYouNote(formData).then((response) {
    //   // Handle response
    // });
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
                        // CustomInputField(
                        //   label: 'Enter Associate Mobile Number',
                        //   isRequired: false,
                        //   controller: associateMobileController,
                        //   enableContactPicker: true, // 👈 Add this
                        // ),
                        // SizedBox(height: 2.h),
                        // Center(
                        //   child: Text('( OR )', style: TTextStyles.Or),
                        // ),
                        // SizedBox(height: 2.h),
                        // // Dropdown with label
                        // MemberDropdown(
                        //   onSelect: (name, uid, chapterId, chapterName) {
                        //     print('✅ Name: $name');
                        //     print('🆔 UID: $uid');
                        //     print('🏷️ Chapter ID: $chapterId');
                        //     print('📛 Chapter Name: $chapterName');

                        //     setState(() {
                        //       selectedPerson =
                        //           name; // or save UID etc. if needed
                        //       selectedPersonId = uid; // <-- store ID instead
                        //     });
                        //   },
                        // ),

                        Row(
                          children: [
                            SizedBox(
                                width:
                                    3.w), // Left padding for the whole tab set
                            Expanded(
                              child: Container(
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
                                                BorderRadius.horizontal(
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

                                    /// ASSOCIATE NUMBER TAB
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
                                                BorderRadius.horizontal(
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
                            ),
                            SizedBox(width: 3.w), // Optional right padding
                          ],
                        ),

                        SizedBox(height: 2.h),

                        /// Show input or dropdown based on selection
                        if (!showMyChapter) ...[
                          CustomInputField(
                            label: 'Enter Associate Mobile Number',
                            isRequired: false,
                            controller: associateMobileController,
                            enableContactPicker: true,
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
                        SizedBox(height: 2.h),

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
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                      border: InputBorder.none,
                                    ),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
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
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Comments",
                            ),
                          ),
                        ),

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
                                child: Text(
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
