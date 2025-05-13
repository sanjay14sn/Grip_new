import 'package:flutter/material.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/constants/Timages.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class VisitorFormPage extends StatefulWidget {
  const VisitorFormPage({super.key});

  @override
  State<VisitorFormPage> createState() => _VisitorFormPageState();
}

class _VisitorFormPageState extends State<VisitorFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    categoryController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    visitDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 2.h),

              // Top Row
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Image.asset(
                    'assets/images/visitors.png',
                    height: 44,
                    width: 44,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Visitors Details',
                    style: TTextStyles.ReferralSlip,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Form Fields with Controllers
              buildInputField('Name*', controller: nameController),
              buildInputField('Company*', controller: companyController),
              buildInputField('Category*', controller: categoryController),
              buildInputField('Mobile*', controller: mobileController),
              buildInputField('Email', controller: emailController),
              buildInputField('Address', controller: addressController, maxLines: 2),
              buildDateField('Visit Date*', controller: visitDateController),

              SizedBox(height: 3.h),

              // Register Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 6.h,
                  decoration: BoxDecoration(
                    gradient: Tcolors.red_button,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
  }

  Widget buildInputField(String label,
      {int maxLines = 1, required TextEditingController controller}) {
    double height = maxLines > 1 ? 114 : 50;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: SizedBox(
        height: height,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
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
      ),
    );
  }

  Widget buildDateField(String label, {required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TTextStyles.visitorsdetails,
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () {
            // Add date picker here if needed
          },
        ),
      ),
    );
  }
}
