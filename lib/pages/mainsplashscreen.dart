import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GripSplashScreen extends StatefulWidget {
  const GripSplashScreen({super.key});

  @override
  State<GripSplashScreen> createState() => _GripSplashScreenState();
}

class _GripSplashScreenState extends State<GripSplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start opacity animation
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to next page after some delay
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        context.push('/splashscreen');
        print("🟢 Splash done, navigate to next screen...");
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
          duration: const Duration(seconds: 4),
          child: Image.asset(
            'assets/images/logo.png', // Correct the asset path as needed
            width: 200, // adjust as needed
          ),
        ),
      ),
    );
  }
}
