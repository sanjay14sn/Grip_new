import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/location_provider.dart';
import 'package:grip/components/Associate_number.dart';
import 'package:grip/components/Dotloader.dart';
import 'package:grip/components/member_dropdown.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OneToOneSlipPage extends StatefulWidget {
  const OneToOneSlipPage({super.key});

  @override
  State<OneToOneSlipPage> createState() => _OneToOneSlipPageState();
}

class _OneToOneSlipPageState extends State<OneToOneSlipPage> {
  String? selectedPerson;
  String? selectedLocation;
  String? fetchedAssociateUid;
  String? selectedPersonId;
  String? selectedDate;

  final List<String> meetingLocations = [
    'At Your Location',
    'At Their Location',
    'At A Common Location'
  ];
  final Color customRed = const Color(0xFFC6221A);
  final BorderRadius boxRadius = BorderRadius.circular(12.0);

  final TextEditingController AssociatenumberController =
      TextEditingController();
  File? _pickedImage;
  bool showMyChapter = true;
  bool isSubmitting = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  void _handleSubmitOneToOne() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);
    print('🚀 Submitting 1-to-1...');

    final String? toMemberId = fetchedAssociateUid ?? selectedPersonId;
    print('👤 Selected toMemberId: $toMemberId');

    if (toMemberId == null ||
        _pickedImage == null ||
        selectedLocation == null) {
      print('⚠️ Missing one or more required fields:');
      print('   toMemberId: $toMemberId');
      print('   _pickedImage: $_pickedImage');
      print('   selectedLocation: $selectedLocation');
      ToastUtil.showToast(context, "Please complete all required fields.");
      setState(() => isSubmitting = false);
      return;
    }

    // Map UI selection to backend enum
    String mappedLocation = '';
    switch (selectedLocation) {
      case 'At Your Location':
        mappedLocation = 'yourlocation';
        break;
      case 'At Their Location':
        mappedLocation = 'theirlocation';
        break;
      case 'At A Common Location':
        mappedLocation = 'commonlocation';
        break;
      default:
        mappedLocation = 'commonlocation';
    }
    print('📍 Selected location: $selectedLocation → $mappedLocation');

    const storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');

    if (userDataString == null) {
      print('❌ Secure storage: user_data not found');
      ToastUtil.showToast(context, "User data not found.");
      setState(() => isSubmitting = false);
      return;
    }

    final userData = jsonDecode(userDataString);
    print('🔐 User data loaded: $userData');

    print('📤 Submitting 1-to-1 slip with:');
    print('   toMember: $toMemberId');
    print('   whereDidYouMeet: $mappedLocation');
    print('   address: ${context.read<LocationProvider>().fullAddress}');
    print('   date: ${DateTime.now().toIso8601String()}');
    print('   imageFile: $_pickedImage');

    final response = await PublicRoutesApiService.submitOneToOneSlip(
      toMember: toMemberId,
      whereDidYouMeet: mappedLocation,
      address: context.read<LocationProvider>().fullAddress ?? '',
      date: DateTime.now().toIso8601String(),
      imageFile: _pickedImage,
    );

    print('📡 API Response:');
    print('   statusCode: ${response.statusCode}');
    print('   success: ${response.isSuccess}');
    print('   message: ${response.message}');
    print('   data: ${response.data}');

    if (response.isSuccess) {
      ToastUtil.showToast(context, '✅ One-to-one Submitted successfully!');
      Navigator.pop(context, true); // Refresh previous screen
    } else {
      ToastUtil.showToast(context, '❌ Failed: ${response.message}');
    }

    setState(() => isSubmitting = false); // Stop loader at the end
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
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
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centers the children horizontally
                      children: [
                        Image.asset(
                          'assets/images/testimonials.png',
                          height: 29.sp,
                          width: 29.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text('One-To-One Slip',
                            style: TTextStyles.ReferralSlip),
                      ],
                    ),

                    SizedBox(height: 3.h),
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
                                      AssociatenumberController.clear();
                                    }),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.5.h),
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
                              controller: AssociatenumberController,
                              enableContactPicker: true,
                              onUidFetched: (uid) {
                                setState(() {
                                  fetchedAssociateUid = uid;
                                });
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
                    SizedBox(height: 2.h),

                    // Where Did You Meet?
                    _simpleDropdown(
                      value: selectedLocation,
                      items: meetingLocations,
                      onChanged: (value) {
                        setState(() => selectedLocation = value);
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Date Picker
                    _datePickerField(),

                    SizedBox(height: 2.h),

                    Stack(
                      children: [
                        // Autofill Address Field (at bottom)
                        Container(
                          margin: const EdgeInsets.only(top: 22),
                          height: 85,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Consumer<LocationProvider>(
                            builder: (context, locationProvider, child) {
                              if (locationProvider.isFetching) {
                                return const Text(
                                    "Fetching current location...");
                              } else if (locationProvider.fullAddress != null) {
                                return Text(locationProvider.fullAddress!);
                              } else {
                                return const Text("Autofill");
                              }
                            },
                          ),
                        ),

                        // Positioned Button (overlapping top-center)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: 260,
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<LocationProvider>()
                                      .fetchLocation();
                                },
                                icon: const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Fetch Live Location",
                                  style: TTextStyles.livelocation,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF50A6C5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Center(
                      child: Column(
                        children: [
                          DottedBorder(
                            color: Color(0xFF50A6C5),
                            dashPattern: [6, 3],
                            strokeWidth: 1.5,
                            child: Container(
                              width: 351,
                              height: 94,
                              color: Color(0xFF50A6C5),
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
                                            child: ElevatedButton(
                                              onPressed: _pickImage,
                                              style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                backgroundColor: Colors.white,
                                                elevation: 4,
                                                shadowColor: Colors.black54,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                size: 24,
                                                color: Color(0xFF50A6C5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Take Photo',
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
                          DottedBorder(
                            color: Color(0xFF50A6C5),
                            dashPattern: [6, 6],
                            strokeWidth: 1.5,
                            child: Container(
                              width: 351,
                              height: 80,
                              child: Center(
                                child: _pickedImage != null
                                    ? Image.file(_pickedImage!,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'No image selected',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.5.h,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _handleSubmitOneToOne,
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
                                ? const DotLoader()
                                : Text("Submit", style: TTextStyles.Submit),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ));
      })),
    );
  }
}

Widget _simpleDropdown({
  required String? value,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 6.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            isExpanded: true,
            value: value,
            hint: const Text("Where Did You Meet"),
            items: items.map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}

Widget _datePickerField() {
  final String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1.h),
      Container(
        height: 6.5.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              todayDate,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    ],
  );
}
