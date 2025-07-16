import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/backend/providers/location_provider.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool _isPermissionGranted = false;
  bool _hasScanned = false;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _isPermissionGranted = true);
    } else {
      var result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() => _isPermissionGranted = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Camera permission is required")),
        );
      }
    }
  }

  Future<void> _handleQRCode(String code) async {
    if (_hasScanned) return;
    setState(() => _hasScanned = true);

    try {
      print('📲 Scanned QR Code: $code');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Lottie.asset("assets/animations/Scanner.json"),
          ),
        ),
      );

      final decoded = jsonDecode(code);
      print('🧩 Decoded QR JSON: $decoded');

      if (decoded is! Map ||
          !decoded.containsKey('meetingId') ||
          !decoded.containsKey('latitude') ||
          !decoded.containsKey('longitude') ||
          !decoded.containsKey('startDate')) {
        debugPrint('❌ QR code parsing error: Essential keys are absent.');
        ToastUtil.showToast(
            context, "Invalid QR code . Please scan a valid one.");
      }

      final String meetingId = decoded['meetingId'];
      final double qrLat = (decoded['latitude'] as num).toDouble();
      final double qrLng = (decoded['longitude'] as num).toDouble();
      final DateTime qrStartDate = DateTime.parse(decoded['startDate']);
      final DateTime? qrEndDate = decoded.containsKey('endDate')
          ? DateTime.tryParse(decoded['endDate'])
          : null;

      print('✅ Meeting ID: $meetingId');
      print('📍 QR Location: ($qrLat, $qrLng)');
      print('🕒 Meeting Start Time: $qrStartDate');
      if (qrEndDate != null) {
        print('🕒 Meeting End Time: $qrEndDate');
      }

      final locationProvider = context.read<LocationProvider>();
      await locationProvider.fetchLocation();

      final double? userLat = locationProvider.latitude;
      final double? userLng = locationProvider.longitude;

      if (userLat == null || userLng == null) {
        print('⚠️ User location unavailable');
        throw Exception("Location unavailable");
      }

      print('📍 User Location: ($userLat, $userLng)');

      final DateTime now = DateTime.now();
      final double distance =
          Geolocator.distanceBetween(userLat, userLng, qrLat, qrLng);
      print(
          '📏 Distance from QR location: ${distance.toStringAsFixed(2)} meters');
      print('🕓 Current time: $now');

      if (distance > 100) {
        print(
            '❌ Too far from location: ${distance.toStringAsFixed(2)}m > 100m');
        throw Exception(
            "Attendance can only be marked when you're in the meeting location");
      }

      if (qrEndDate != null && now.isAfter(qrEndDate)) {
        print('⏰ Meeting already ended: $now > $qrEndDate');
        throw Exception("Meeting has already ended.");
      }

      print('📡 Sending attendance request...');
      final response = await PublicRoutesApiService.markAttendance(meetingId);

      await Future.delayed(const Duration(milliseconds: 700));
      if (!context.mounted) return;

      Navigator.of(context).pop(); // dismiss loading

      if (response.isSuccess) {
        print('✅ Attendance marked successfully');
        ToastUtil.showToast(context, "✅ Attendance marked successfully!");
        context.push('/AttendanceSuccess');
      } else {
        print('❌ Attendance failed: ${response.message}');
        ToastUtil.showToast(context, response.message ?? "Attendance failed");
        context.push('/attendance-failure', extra: response.message);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        print('❌ Exception: $e');
        ToastUtil.showToast(context, e.toString());
        context.push('/attendance-failure', extra: e.toString());
      }
    } finally {
      await _scannerController.stop();
      print('🔒 Scanner stopped');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Scan QR Code", style: TextStyle(color: Colors.white)),
        backgroundColor: Tcolors.title_color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isPermissionGranted
          ? Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    final String? code = barcode.rawValue;
                    if (code != null && !_hasScanned) {
                      _handleQRCode(code);
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ScannerOverlayPainter(scanAreaSize: 250),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Point your camera at a QR code',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  ScannerOverlayPainter({required this.scanAreaSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final cutOut = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectXY(cutOut, 16, 16)),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
