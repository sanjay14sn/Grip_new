import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ThankYouNotePage extends StatefulWidget {
  const ThankYouNotePage({super.key});

  @override
  State<ThankYouNotePage> createState() => _ThankYouNotePageState();
}

class _ThankYouNotePageState extends State<ThankYouNotePage> {
  String? selectedPerson;
  final List<String> personList = ['Person A', 'Person B', 'Person C'];
  final Color customRed = const Color(0xFFC6221A);

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
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                            // SizedBox(width: 1.w),
                            Text('Thank U Note Slip',
                                style: TTextStyles.ReferralSlip),
                          ],
                        ),

                        SizedBox(height: 1.h),

                        // Dropdown with label
                        Container(
                          height: 6.5.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedPerson,
                                    hint: const Text("Thnak you To:"),
                                    items: personList.map((e) {
                                      return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPerson = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Icon(Icons.search, color: customRed),
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
                                  color: customRed.withOpacity(0.9),
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
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.number,
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
                          child: const TextField(
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
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
                            onPressed: () {},
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
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFC02221),
                                    Color(0xFFF2AAAA)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Home Icon at bottom
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
