import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool _isPermissionGranted = false;
  bool _hasScanned = false;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _checkPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          SnackBar(content: Text("Camera permission is required")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR Code for Attendance',
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
        backgroundColor: Tcolors.title_color,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isPermissionGranted
          ? Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) async {
                    if (_hasScanned) return;

                    final barcode = capture.barcodes.first;
                    final String? code = barcode.rawValue;

                    if (code != null && !_hasScanned) {
                      setState(() => _hasScanned = true);
                      await _controller.stop(); // 🛑 stop the camera stream

                      await Future.delayed(const Duration(seconds: 1));

                      if (!mounted) return;

                      if (code.startsWith("GRIP-")) {
                        context.push('/AttendanceSuccess');
                      } else {
                        context.push('/AttendanceFailure');
                      }
                    }
                  },
                ),

                // 🔳 Scanning box
                Center(
                  child: Container(
                    width: 65.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5.w),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                ),

                // 🔲 Transparent overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ScannerOverlayPainter(scanAreaSize: 65.w),
                    ),
                  ),
                ),

                // 🔤 Instruction text
                Positioned(
                  bottom: 5.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Text(
                        'Point your camera at a QR code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
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

    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectXY(cutOutRect, 3.w, 3.w)),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:grip/backend/api-requests/no_auth_api.dart';
// import 'package:grip/backend/providers/location_provider.dart';
// import 'package:grip/utils/constants/Tcolors.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';

// class QRScanPage extends StatefulWidget {
//   @override
//   State<QRScanPage> createState() => _QRScanPageState();
// }

// class _QRScanPageState extends State<QRScanPage> {
//   bool _isPermissionGranted = false;
//   bool _hasScanned = false;
//   final MobileScannerController _scannerController = MobileScannerController();

//   @override
//   void initState() {
//     super.initState();
//     _checkPermission();
//   }

//   @override
//   void dispose() {
//     _scannerController.dispose();
//     super.dispose();
//   }

//   Future<void> _checkPermission() async {
//     var status = await Permission.camera.status;
//     if (status.isGranted) {
//       print("✅ Camera permission already granted");
//       setState(() => _isPermissionGranted = true);
//     } else {
//       var result = await Permission.camera.request();
//       if (result.isGranted) {
//         print("✅ Camera permission granted after request");
//         setState(() => _isPermissionGranted = true);
//       } else {
//         print("❌ Camera permission denied");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission is required")),
//         );
//       }
//     }
//   }

//   Future<void> _handleQRCode(String code) async {
//     if (_hasScanned) return;
//     setState(() => _hasScanned = true);

//     try {
//       print("🔍 QR code detected: $code");
//       final decoded = jsonDecode(code);

//       if (decoded is! Map) {
//         throw FormatException('❌ QR is not a valid JSON object');
//       }

//       if (!decoded.containsKey('meetingId') ||
//           !decoded.containsKey('latitude') ||
//           !decoded.containsKey('longitude') ||
//           !decoded.containsKey('date')) {
//         throw FormatException('❌ QR code is missing required fields');
//       }

//       final String meetingId = decoded['meetingId'];
//       final double qrLat = (decoded['latitude'] as num).toDouble();
//       final double qrLng = (decoded['longitude'] as num).toDouble();
//       final DateTime qrDate = DateTime.parse(decoded['date']);

//       print('📲 Meeting ID: $meetingId');
//       print('📍 QR Coordinates: $qrLat, $qrLng');
//       print('📆 Meeting DateTime: $qrDate');

//       final locationProvider = context.read<LocationProvider>();
//       print('📡 Fetching user location...');
//       await locationProvider.fetchLocation();

//       if (locationProvider.latitude == null ||
//           locationProvider.longitude == null) {
//         print("⚠️ User location unavailable");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Unable to fetch your location")),
//         );
//         context.push('/AttendanceFailure');
//         return;
//       }

//       final double userLat = locationProvider.latitude!;
//       final double userLng = locationProvider.longitude!;
//       final DateTime now = DateTime.now();

//       print("📍 User Coordinates: $userLat, $userLng");
//       print("🕒 Current Time: $now");

//       double distanceInMeters =
//           Geolocator.distanceBetween(userLat, userLng, qrLat, qrLng);
//       print(
//           '📏 Distance from meeting: ${distanceInMeters.toStringAsFixed(2)} meters');

//       if (distanceInMeters > 100) {
//         print("❌ Too far from meeting location");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('You are too far from the meeting location')),
//         );
//         context.push('/AttendanceFailure');
//         return;
//       }

//       if (now.isBefore(qrDate)) {
//         print("⏳ Meeting has not started yet");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Meeting has not started yet')),
//         );
//         context.push('/AttendanceFailure');
//         return;
//       }

//       // ✅ All validations passed
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Verifying attendance...')),
//       );

//       print("✅ Sending attendance mark API call...");
//       final ApiResponse response =
//           await PublicRoutesApiService.markAttendance(meetingId);
//       await Future.delayed(const Duration(seconds: 1));

//       if (!context.mounted) return;

//       if (response.isSuccess) {
//         print("✅ Attendance success");
//         context.push('/AttendanceSuccess');
//       } else {
//         print("❌ Attendance failed: ${response.message}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(response.message ?? 'Failed')),
//         );
//         context.push('/AttendanceFailure');
//       }
//     } catch (e) {
//       print('❌ Error while processing QR: ${e.toString()}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid QR Code')),
//       );
//       context.push('/AttendanceFailure');
//     } finally {
//       await _scannerController.stop(); // Stop to release camera buffers
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
//         backgroundColor: Tcolors.title_color,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: _isPermissionGranted
//           ? Stack(
//               children: [
//                 MobileScanner(
//                   controller: _scannerController,
//                   onDetect: (capture) {
//                     final barcode = capture.barcodes.first;
//                     final String? code = barcode.rawValue;
//                     if (code != null && !_hasScanned) {
//                       _handleQRCode(code);
//                     }
//                   },
//                 ),
//                 // Scan Area Box
//                 Center(
//                   child: Container(
//                     width: 250,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.white, width: 2),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ),
//                 // Dimmed Overlay
//                 Positioned.fill(
//                   child: IgnorePointer(
//                     child: CustomPaint(
//                       painter: ScannerOverlayPainter(scanAreaSize: 250),
//                     ),
//                   ),
//                 ),
//                 // Text Instruction
//                 Positioned(
//                   bottom: 40,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         'Point your camera at a QR code',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// class ScannerOverlayPainter extends CustomPainter {
//   final double scanAreaSize;

//   ScannerOverlayPainter({required this.scanAreaSize});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     final cutOutRect = Rect.fromCenter(
//       center: Offset(size.width / 2, size.height / 2),
//       width: scanAreaSize,
//       height: scanAreaSize,
//     );

//     final path = Path.combine(
//       PathOperation.difference,
//       Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
//       Path()..addRRect(RRect.fromRectXY(cutOutRect, 16, 16)),
//     );

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
