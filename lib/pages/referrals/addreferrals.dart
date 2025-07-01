import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/Dotloader.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool isSubmitting = false;

  String? selectedPersonName; // For UI
  String? selectedPersonId; // For API (toMember)
  String? fetchedAssociateUid;

  final TextEditingController associatenumber = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  void _handleSubmitReferral() async {
    if (isSubmitting) return; // Prevent double submits
    setState(() => isSubmitting = true);
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final address = addressController.text.trim();
    final comments = commentsController.text.trim();

    // 🔒 Check all fields are filled
    if (name.isEmpty || mobile.isEmpty || comments.isEmpty) {
      ToastUtil.showToast(context, "Please fill all required fields");
      return;
    }

    if (name.length > 50) {
      ToastUtil.showToast(context, "Name must be under 50 characters");
      return;
    }

    if (mobile.length != 10 || !RegExp(r'^\d{10}$').hasMatch(mobile)) {
      ToastUtil.showToast(context, "Mobile number must be exactly 10 digits");
      return;
    }

    if (comments.length > 150) {
      ToastUtil.showToast(context, "Comments must be under 150 characters");
      return;
    }

    final String? toMemberId =
        showMyChapter ? selectedPersonId : fetchedAssociateUid;

    if (toMemberId == null || toMemberId.isEmpty) {
      ToastUtil.showToast(
          context, "Please select a member or enter associate number");
      return;
    }

    String status = toldThemYouWouldCall
        ? 'told them you would call'
        : givenYourCard
            ? 'given your card'
            : '';

    if (status.isEmpty) {
      ToastUtil.showToast(context, "Please select referral status");
      return;
    }

    final referalDetail = {
      'name': name,
      'category': 'Plumber',
      'mobileNumber': mobile,
      'comments': comments,
      'address': address,
    };

    final response = await PublicRoutesApiService.submitReferralSlip(
      toMember: toMemberId,
      referalStatus: status,
      referalDetail: referalDetail,
    );

    if (response.isSuccess) {
      ToastUtil.showToast(context, "Referral slip submitted successfully");
      Navigator.pop(context, true);
    } else {
      ToastUtil.showToast(context, "❌ ${response.message}");
    }
    setState(() => isSubmitting = false);
  }

  Widget buildInputField(
    String label,
    bool isRequired, {
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "",
          hintText: isRequired ? "$label" : label,
          hintStyle: TTextStyles.visitorsdetails,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> pickContact() async {
    final status = await Permission.contacts.status;

    if (status.isGranted) {
      // Permission already granted
      await _openAndFillContact();
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      // Ask for permission
      final result = await Permission.contacts.request();

      if (result.isGranted) {
        await _openAndFillContact();
      } else {
        ToastUtil.showToast(
            context, '📛 Contact permission is required to pick a contact');
      }
    } else if (status.isPermanentlyDenied) {
      // Permanently denied — direct to app settings
      ToastUtil.showToast(context,
          '🔒 Contact permission permanently denied. Please enable it in settings.');
      await openAppSettings();
    }
  }

  Future<void> _openAndFillContact() async {
    try {
      final List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      if (contacts.isEmpty) {
        ToastUtil.showToast(context, 'No contacts found');
        return;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          TextEditingController searchController = TextEditingController();
          List<Contact> filteredContacts = List.from(contacts);

          return StatefulBuilder(
            builder: (context, setModalState) {
              void filterContacts(String query) {
                final lowerQuery = query.toLowerCase();
                setModalState(() {
                  filteredContacts = contacts.where((contact) {
                    final name = contact.displayName.toLowerCase();
                    final phone = contact.phones.isNotEmpty
                        ? contact.phones.first.number.toLowerCase()
                        : '';
                    return name.contains(lowerQuery) ||
                        phone.contains(lowerQuery);
                  }).toList();
                });
              }

              return SizedBox(
                height: 60.h,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name or phone',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: filterContacts,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          final phone = contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : '';

                          return ListTile(
                            title: Text(contact.displayName),
                            subtitle: Text(phone),
                            onTap: () {
                              nameController.text = contact.displayName;
                              if (phone.isNotEmpty) {
                                mobileController.text = phone
                                    .replaceAll(RegExp(r'\D'), '')
                                    .padLeft(10, '0')
                                    .substring(0, 10);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      print('❌ Failed to load contacts: $e');
      ToastUtil.showToast(context, 'Error loading contacts');
    }
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
                                    borderRadius: BorderRadius.circular(2)),
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
                                      if (val)
                                        givenYourCard =
                                            false; // ensure only one is selected
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
                                      if (val)
                                        toldThemYouWouldCall =
                                            false; // ensure only one is selected
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
                          buildInputField(
                            "Name*",
                            true,
                            controller: nameController,
                            maxLength: 50,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.contact_page,
                                  color: Colors.grey[700]),
                              onPressed: pickContact,
                            ),
                          ),

                          buildInputField(
                            "Mobile*",
                            true,
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                          buildInputField(
                            "Address(Or)Area",
                            true,
                            controller: addressController,
                            maxLength: 150,
                          ),
                          buildInputField("Comments", true,
                              controller: commentsController,
                              maxLength: 150,
                              maxLines: 4),
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
                              onPressed:
                                  isSubmitting ? null : _handleSubmitReferral,
                              child: isSubmitting
                                  ? const DotLoader(
                                      color: Colors.white,
                                      size: 10,
                                    )
                                  : Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
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
