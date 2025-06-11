import 'dart:io';
import 'dart:ui';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:grip/providers/location_provider.dart';
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
  String? selectedDate;
  final List<String> personList = ['Person A', 'Person B', 'Person C'];
  final List<String> meetingLocations = [
    'At Your Location',
    'At Their Location',
    'At A Common Location'
  ];
  final Color customRed = const Color(0xFFC6221A);
  final BorderRadius boxRadius = BorderRadius.circular(12.0);

  final TextEditingController commentController = TextEditingController();
  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: SingleChildScrollView(
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
                      Text('One-To-Ones Slip', style: TTextStyles.ReferralSlip),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  Container(
                    height: 6.5.h,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F9),
                      borderRadius: boxRadius,
                    ),
                    child: TextField(
                      controller: commentController,
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter associate mobile number',
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Text('( OR )', style: TTextStyles.Or),
                  ),
                  SizedBox(height: 2.h),
                  // Met With Dropdown
                  _labelledDropdownWithSearch(
                    hint: "Met With:",
                    value: selectedPerson,
                    items: personList,
                    onChanged: (value) {
                      setState(() => selectedPerson = value);
                    },
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
                        margin: EdgeInsets.only(top: 22),
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
                              return const CircularProgressIndicator();
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
                                backgroundColor: Color(0xFF50A6C5),
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
                                              padding: const EdgeInsets.all(10),
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
                                      width: 70, height: 70, fit: BoxFit.cover)
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
                          gradient: Tcolors.red_button,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: Text("Submit", style: TTextStyles.Submit),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _labelledDropdownWithSearch({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      height: 6.5.h,
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
                value: value,
                hint: Text(hint),
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
          const Icon(Icons.search, color: Colors.red),
        ],
      ),
    );
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
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
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
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
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
}
