import 'dart:async';
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

    // Start logo fade-in
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // After splash delay, check auth and navigate accordingly
    Timer(const Duration(seconds: 4), () async {
      if (!mounted) return;

      final token = await storage.read(key: 'auth_token');
      final userData = await storage.read(key: 'user_data');

      if (token != null && userData != null) {
        context.go('/homepage'); // ✅ Go to homepage
        // context.go('/token'); // ✅ Go to homepage
      } else {
        context.go('/login'); // ❌ Not logged in, go to login
      }
    });
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
            'assets/images/logo.png', // ✅ Replace with your correct path
            width: 200,
          ),
        ),
      ),
    );
  }
}
