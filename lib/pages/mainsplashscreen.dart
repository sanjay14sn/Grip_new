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
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => _opacity = 1.0);
    }

    await Future.delayed(const Duration(seconds: 3));

    try {
      final token = await storage.read(key: 'auth_token');
      final userData = await storage.read(key: 'user_data');
      final expiryString = await storage.read(key: 'token_expiry');

      if (!mounted) return;

      if (token != null && userData != null && expiryString != null) {
        final expiryDate = DateTime.tryParse(expiryString);

        if (expiryDate != null) {
          if (DateTime.now().isBefore(expiryDate)) {
            context.go('/homepage');
            return;
          } else {
            await storage.deleteAll();
            context.go('/splashscreen');
            return;
          }
        } else {}
      }

      context.go('/splashscreen');
    } catch (e) {
      if (mounted) {
        context.go('/splashscreen');
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
            'assets/images/Griplogo.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
