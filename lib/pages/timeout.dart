import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:go_router/go_router.dart';

class TokenValidityPage extends StatefulWidget {
  const TokenValidityPage({super.key});

  @override
  State<TokenValidityPage> createState() => _TokenValidityPageState();
}

class _TokenValidityPageState extends State<TokenValidityPage> {
  static const storage = FlutterSecureStorage();

  String? _token;
  Duration? _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await storage.read(key: 'auth_token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      setState(() {
        _token = token;
      });

      _startCountdown(token);
    } else {
      _logout();
    }
  }

  void _startCountdown(String token) {
    DateTime expiryDate = JwtDecoder.getExpirationDate(token);
    Duration duration = expiryDate.difference(DateTime.now());

    _remainingTime = duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = expiryDate.difference(now);

      if (remaining.isNegative) {
        timer.cancel();
        _logout();
      } else {
        setState(() {
          _remainingTime = remaining;
        });
      }
    });
  }

  Future<void> _logout() async {
    await storage.deleteAll();
    if (context.mounted) {
      context.go('/login'); // Replace with your login route
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Token Validity")),
      body: Center(
        child: _token == null
            ? const Text("🔐 No valid token found.")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_clock, size: 48),
                  const SizedBox(height: 20),
                  const Text("⏳ Token expires in:",
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text(
                    _formatDuration(_remainingTime),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
