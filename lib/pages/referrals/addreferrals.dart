import 'package:flutter/material.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool toldThemYouWouldCall = false;
  bool givenYourCard = false;
  final Color customRed = const Color(0xFFC6221A);
  String? selectedPerson;

  final TextEditingController associatenumber = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: LayoutBuilder(
              // Use LayoutBuilder for proper constraint resolution
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: ConstrainedBox(
                    // Add ConstrainedBox to enforce max height
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      // Use IntrinsicHeight for proper sizing
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
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 2.w),
                                Image.asset(
                                  'assets/images/referalslip.png',
                                  height: 18.sp,
                                  width: 18.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text('Referral Slip',
                                    style: TTextStyles.ReferralSlip),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          CustomInputField(
                            label: 'Enter Associate Mobile Number',
                            isRequired: false,
                            controller: associatenumber,
                            enableContactPicker: true, // 👈 Add this
                          ),
                          Center(
                            child: Text('( OR )', style: TTextStyles.Or),
                          ),
                          SizedBox(height: 2.h),
                          MemberDropdown(
                            onSelect: (name, uid, chapterId, chapterName) {
                              print('✅ Name: $name');
                              print('🆔 UID: $uid');
                              print('🏷️ Chapter ID: $chapterId');
                              print('📛 Chapter Name: $chapterName');

                              setState(() {
                                selectedPerson =
                                    name; // or save UID etc. if needed
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          Text("Referral Status:",
                              style: TTextStyles.profiledetails),
                          Divider(color: const Color(0x80C0C0C0), thickness: 1),
                          Flexible(
                            // Wrap in Flexible for proper layout
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Color(0xFFC83837),
                                    checkboxTheme: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      side: BorderSide(
                                          color: Color(0xFFC83837), width: 2),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: toldThemYouWouldCall,
                                    onChanged: (val) {
                                      setState(() {
                                        toldThemYouWouldCall = val!;
                                      });
                                    },
                                    title:
                                        const Text("Told Them You Would Call"),
                                    activeColor: Color(0xFFC83837),
                                    checkColor: Colors.white,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    dense: true,
                                  ),
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Color(0xFFC83837),
                                    checkboxTheme: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      side: BorderSide(
                                          color: Color(0xFFC83837), width: 2),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    value: givenYourCard,
                                    onChanged: (val) {
                                      setState(() {
                                        givenYourCard = val!;
                                      });
                                    },
                                    title: const Text("Given Your Card"),
                                    activeColor: Color(0xFFC83837),
                                    checkColor: Colors.white,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    dense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          buildInputField("Name*", true,
                              controller: nameController),
                          buildInputField("Mobile*", true,
                              controller: mobileController,
                              keyboardType: TextInputType.phone),
                          buildInputField("Address(Or)Area", false,
                              controller: addressController),
                          buildInputField("Comments", false,
                              controller: commentsController, maxLines: 4),
                          SizedBox(height: 3.h),
                          Container(
                            width: double.infinity,
                            height: 6.h,
                            decoration: BoxDecoration(
                              gradient: Tcolors.red_button,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildInputField(
    String label,
    bool isRequired, {
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: isRequired ? "$label" : label,
          hintStyle: TTextStyles.visitorsdetails,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
