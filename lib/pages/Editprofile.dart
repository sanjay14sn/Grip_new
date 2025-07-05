import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grip/pages/toastutill.dart' show ToastUtil;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ProfileFormPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String companyName;
  final String? profileImageUrl;

  const ProfileFormPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    this.profileImageUrl,
  });

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController companyController;

  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    companyController = TextEditingController(text: widget.companyName);
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
        });
      }
    } else if (status.isDenied) {
      ToastUtil.showToast(context, "Permission denied to access gallery.");
    } else if (status.isPermanentlyDenied) {
      ToastUtil.showToast(context,
          "Permission permanently denied. Please enable it from settings.");
      openAppSettings();
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final company = companyController.text.trim();

     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title:
              const Text("Edit Profile", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📸 Profile Image Section
                  Text(
                    "Profile Image",
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35.sp,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : widget.profileImageUrl != null
                                  ? NetworkImage(widget.profileImageUrl!)
                                  : const AssetImage(
                                          'assets/images/sample_profile.jpg')
                                      as ImageProvider,
                          backgroundColor: Colors.grey[300],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  /// 📝 First Name
                  Text("First Name *", style: _labelStyle()),
                  SizedBox(height: 0.8.h),
                  _buildTextField(
                      controller: firstNameController,
                      hint: "Enter first name"),

                  SizedBox(height: 2.h),

                  /// 📝 Last Name
                  Text("Last Name *", style: _labelStyle()),
                  SizedBox(height: 0.8.h),
                  _buildTextField(
                      controller: lastNameController, hint: "Enter last name"),

                  SizedBox(height: 2.h),

                  /// 🏢 Company Name
                  Text("Company Name *", style: _labelStyle()),
                  SizedBox(height: 0.8.h),
                  _buildTextField(
                      controller: companyController,
                      hint: "Enter company name"),

                  SizedBox(height: 4.h),

                  /// ✅ Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6221A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'This field is required'
          : null,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  TextStyle _labelStyle() =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
}
