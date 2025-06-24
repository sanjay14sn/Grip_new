import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/auth_api.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Timages.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // ✅ Form key

  @override
  void initState() {
    super.initState();

    // Close keyboard after entering 10 digits
    usernameController.addListener(() {
      if (usernameController.text.length == 10) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // 🔒 Close the keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final mobileNumber = usernameController.text.trim();
      final pin = passwordController.text;

      print('🔐 Attempting login with username: $mobileNumber');

      try {
        final response = await PublicRoutesApi.Login(
          mobileNumber: mobileNumber,
          pin: pin,
        );

        print('📡 API Response Status: ${response.statusCode}');

        final responseDataString = response.data.toString();
        final truncatedResponse = responseDataString.length > 500
            ? '${responseDataString.substring(0, 500)}... [truncated]'
            : responseDataString;
        print('📡 API Response Body: $truncatedResponse');

        if (response.isSuccess && response.data['success'] == true) {
          final token = response.data['token'];
          final userJson = response.data['member'];

          print('✅ Login successful.');
          print(
              '🔑 Token: ${token.toString().substring(0, 30)}... [truncated]');
          print('👤 User Info: $userJson');

          // ✅ Store token and user data in secure storage
          const storage = FlutterSecureStorage();
          await storage.write(key: 'auth_token', value: token);
          await storage.write(key: 'user_data', value: jsonEncode(userJson));

          // ✅ Show success toast
          ToastUtil.showToast(context, '✅ Login successful!');

          // ✅ Navigate to homepage
          context.go('/homepage');
        } else {
          final message = response.data?['message'] ?? response.message;
          ToastUtil.showToast(context, 'Login failed. Message: $message');
        }
      } catch (e) {
        print('❌ Login error: $e');
        ToastUtil.showToast(
            context, 'An unexpected error occurred. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Timages.courtbackground,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                backgroundBlendMode: BlendMode.darken,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: _formKey, // ✅ Wrap with Form
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Timages.griplogo),
                        const SizedBox(height: 50),
                        _InputBox(
                          controller: usernameController,
                          hinttext: 'Mobile Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                        ),
                        _InputBox(
                          controller: passwordController,
                          hinttext: 'PIN',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap:
                                _handleLogin, // ✅ Use validation before navigation
                            child: Container(
                              height: 6.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                gradient: Tcolors.red_button,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;

  const _InputBox({
    required this.controller,
    required this.hinttext,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "", // hides character counter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Tcolors.bottombar,
              width: 3,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Tcolors.bottombar.withOpacity(0.5),
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Tcolors.bottombar,
              width: 3,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ),
      ),
    );
  }
}
