import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
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

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<void> _handleRegister() async {
    print('📝 Starting registration...');

    if (nameController.text.isEmpty ||
        companyController.text.isEmpty ||
        categoryController.text.isEmpty ||
        mobileController.text.isEmpty ||
        visitDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields (*)')),
      );
      return;
    }

    final requestBody = {
      "name": nameController.text.trim(),
      "company": companyController.text.trim(),
      "category": categoryController.text.trim(),
      "mobile": mobileController.text.trim(),
      "email": emailController.text.trim(),
      "address": addressController.text.trim(),
      "visitDate": visitDateController.text.trim(),
    };

    print('📦 Submitting visitor: $requestBody');

    final response = await PublicRoutesApiService.registerVisitor(requestBody);

    if (response.isSuccess) {
      ToastUtil.showToast(
          response.message ?? 'Visitor registered successfully');

      // ✅ Clear form
      nameController.clear();
      companyController.clear();
      categoryController.clear();
      mobileController.clear();
      emailController.clear();
      addressController.clear();
      visitDateController.clear();

      // ✅ Return to previous screen and notify success
      Navigator.pop(context, true); // 👈 this triggers refresh on home
    } else {
      print('❌ Registration failed: ${response.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${response.message}')),
      );
    }
  }

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
              buildInputField('Address', controller: addressController),
              buildDateField('Visit Date*', controller: visitDateController),

              SizedBox(height: 3.h),

              // Register Button
              Center(
                child: GestureDetector(
                  onTap: _handleRegister,
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

  Widget buildDateField(String label,
      {required TextEditingController controller}) {
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
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              final fixedTime =
                  DateTime(picked.year, picked.month, picked.day, 10, 30);
              visitDateController.text = fixedTime.toIso8601String();
            }
          },
        ),
      ),
    );
  }
}
