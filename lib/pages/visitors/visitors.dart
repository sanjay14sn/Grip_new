import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
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

  String? visitDateISO; // for backend

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> _handleRegister() async {
    final name = nameController.text.trim();
    final company = companyController.text.trim();
    final category = categoryController.text.trim();
    final mobile = mobileController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty ||
        company.isEmpty ||
        category.isEmpty ||
        mobile.isEmpty ||
        address.isEmpty ||
        visitDateController.text.isEmpty) {
      ToastUtil.showToast(context, "Please fill all required fields (*)");
      return;
    }

    if (name.length > 50) {
      ToastUtil.showToast(context, "Name must be under 50 characters");
      return;
    }

    if (company.length > 70) {
      ToastUtil.showToast(context, "Company must be under 70 characters");
      return;
    }

    if (category.length > 70) {
      ToastUtil.showToast(context, "Category must be under 70 characters");
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      ToastUtil.showToast(context, "Mobile number must be exactly 10 digits");
      return;
    }

    if (email.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ToastUtil.showToast(context, "Please enter a valid email address");
      return;
    }

    if (address.length > 200) {
      ToastUtil.showToast(context, "Address must be under 200 characters");
      return;
    }

    final requestBody = {
      "name": name,
      "company": company,
      "category": category,
      "mobile": mobile,
      "email": email,
      "address": address,
      "visitDate": visitDateISO,
    };

    final response = await PublicRoutesApiService.registerVisitor(requestBody);

    if (response.isSuccess) {
      ToastUtil.showToast(
          context, response.message ?? 'Visitor registered successfully');

      // Clear form
      nameController.clear();
      companyController.clear();
      categoryController.clear();
      mobileController.clear();
      emailController.clear();
      addressController.clear();
      visitDateController.clear();
      visitDateISO = null;

      Navigator.pop(context, true);
    } else {
      ToastUtil.showToast(context, "❌ ${response.message}");
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  SizedBox(width: 3.w),
                  Image.asset('assets/images/visitors.png',
                      height: 44, width: 44),
                  SizedBox(width: 2.w),
                  Text('Visitors Details', style: TTextStyles.ReferralSlip),
                ],
              ),
              SizedBox(height: 2.h),
              buildInputField('Name*', controller: nameController),
              buildInputField('Company*', controller: companyController),
              buildInputField('Category*', controller: categoryController),
              buildInputField('Mobile*', controller: mobileController),
              buildInputField('Email', controller: emailController),
              buildInputField('Address',
                  controller: addressController, maxLines: 3),
              buildDateField('Visit Date*', controller: visitDateController),
              SizedBox(height: 3.h),
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
              visitDateISO =
                  DateTime(picked.year, picked.month, picked.day, 10, 30)
                      .toIso8601String();
              controller.text = DateFormat('dd-MM-yyyy').format(picked);
            }
          },
        ),
      ),
    );
  }
}
