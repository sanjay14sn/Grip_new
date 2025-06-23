import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
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
  bool showMyChapter = true;

  String? selectedPersonName; // For UI
  String? selectedPersonId; // For API (toMember)
  String? fetchedAssociateUid;

  final TextEditingController associatenumber = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  void _handleSubmitReferral() async {
    final String? toMemberId =
        showMyChapter ? selectedPersonId : fetchedAssociateUid;

    if (toMemberId == null || toMemberId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a member or enter associate number"),
        ),
      );
      return;
    }

    String status = '';
    if (toldThemYouWouldCall) status = 'told them you would call';
    if (givenYourCard) {
      status = status.isEmpty ? 'given your card' : '$status & given your card';
    }

    final referalDetail = {
      'name': nameController.text.trim(),
      'category': 'Plumber', // Replace with dynamic input if needed
      'mobileNumber': mobileController.text.trim(),
      'comments': commentsController.text.trim(),
      'address': addressController.text.trim(),
    };

    final response = await PublicRoutesApiService.submitReferralSlip(
      toMember: toMemberId,
      referalStatus: status,
      referalDetail: referalDetail,
    );

    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral slip submitted successfully')),
      );
      Navigator.pop(context, true); // 👈 this triggers refresh on home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
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

                          /// Toggle switch between MY CHAPTER and OTHER CHAPTERS
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
                                            associatenumber.clear();
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
                                            selectedPersonName = null;
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
                                    controller: associatenumber,
                                    enableContactPicker: true,
                                    onUidFetched: (uid) {
                                      setState(() {
                                        fetchedAssociateUid = uid;
                                      });
                                    },
                                  ),
                                ] else ...[
                                  MemberDropdown(
                                    onSelect:
                                        (name, uid, chapterId, chapterName) {
                                      setState(() {
                                        selectedPersonName = name;
                                        selectedPersonId = uid;
                                      });
                                    },
                                  ),
                                ],

                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 2.h,
                          ),
                          Text("Referral Status:",
                              style: TTextStyles.profiledetails),
                          Divider(color: const Color(0x80C0C0C0), thickness: 1),
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
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: toldThemYouWouldCall,
                                  onChanged: (val) {
                                    setState(() {
                                      toldThemYouWouldCall = val!;
                                    });
                                  },
                                  title: const Text("Told Them You Would Call"),
                                  activeColor: Color(0xFFC83837),
                                  checkColor: Colors.white,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  dense: true,
                                ),
                                CheckboxListTile(
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
                              onPressed: _handleSubmitReferral,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
