import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class GripSplashScreen extends StatefulWidget {
  const GripSplashScreen({super.key});

  @override
  State<GripSplashScreen> createState() => _GripSplashScreenState();
}

class _GripSplashScreenState extends State<GripSplashScreen> {
  double _opacity = 0.0;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    print('🌀 Splash sequence started...');

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _opacity = 1.0);
      print('✨ Logo fade-in triggered');
    }

    await Future.delayed(const Duration(seconds: 3));
    print('⏳ Splash duration complete. Checking auth...');

    try {
      final token = await storage.read(key: 'auth_token');
      final userData = await storage.read(key: 'user_data');
      final expiryString = await storage.read(key: 'token_expiry');

      print('🔍 Token: ${token != null ? '[FOUND]' : '[NOT FOUND]'}');
      print('🔍 User Data: ${userData != null ? '[FOUND]' : '[NOT FOUND]'}');
      print('🔍 Expiry: ${expiryString ?? '[NOT FOUND]'}');

      if (!mounted) return;

      if (token != null && userData != null && expiryString != null) {
        final expiryDate = DateTime.tryParse(expiryString);

        if (expiryDate != null) {
          print('📆 Token Expiry Date: $expiryDate');
          if (DateTime.now().isBefore(expiryDate)) {
            print('✅ Token is valid. Redirecting to /homepage');
            context.go('/homepage');
            return;
          } else {
            print('❌ Token has expired. Clearing storage...');
            await storage.deleteAll();
            context.go('/login');
            return;
          }
        } else {
          print('⚠️ Failed to parse expiry date.');
        }
      }

      print('🚪 Token or user info missing. Redirecting to /login');
      context.go('/login');
    } catch (e) {
      print("❌ Storage error occurred: $e");
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
