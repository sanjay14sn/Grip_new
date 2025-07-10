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

      try {
        const storage = FlutterSecureStorage();
        final fcmToken =
            await storage.read(key: 'fcm_token'); // ✅ Read FCM token

        if (fcmToken != null && fcmToken.isNotEmpty) {
        } else {}

        final response = await PublicRoutesApi.Login(
          mobileNumber: mobileNumber,
          pin: pin,
          fcmToken: fcmToken, // ✅ Pass FCM token here
        );

        final responseDataString = response.data.toString();
        final truncatedResponse = responseDataString.length > 500
            ? '${responseDataString.substring(0, 500)}... [truncated]'
            : responseDataString;

        if (response.isSuccess && response.data['success'] == true) {
          final token = response.data['token'];

// 🔒 Safely log part of the token for debugging (do not expose full token)

          final userJson = response.data['member'];

          await storage.write(key: 'auth_token', value: token);
          await storage.write(key: 'user_data', value: jsonEncode(userJson));

          // ✅ Decode token expiry and save
          final expiryDate = _getTokenExpiry(token);
          if (expiryDate != null) {
            await storage.write(
              key: 'token_expiry',
              value: expiryDate.toIso8601String(),
            );
          } else {}

          ToastUtil.showToast(context, '✅ Login successful!');
          context.go('/homepage');
        } else {
          final rawMessage = response.data?['message'] ?? response.message;
          final message = (rawMessage == 'Invalid PIN' ||
                  rawMessage == 'Invalid mobile number')
              ? rawMessage
              : 'Please Try Again';

          ToastUtil.showToast(context, message);
        }
      } catch (e) {
        ToastUtil.showToast(context, 'Please Try Again');
      }
    }
  }

  DateTime? _getTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      if (payloadMap is! Map || !payloadMap.containsKey('exp')) return null;

      final exp = payloadMap['exp'];
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // <--- Important
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
                child: SingleChildScrollView(
                  // <--- Wrap with scroll
                  padding: EdgeInsets.only(
                    left: 50,
                    right: 50,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Timages.griplogo),
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
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter PIN';
                            }
                            if (value.length < 4) {
                              return 'PIN must be at least 4 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: _handleLogin,
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
