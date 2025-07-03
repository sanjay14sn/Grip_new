import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  bool _isPermissionGranted = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
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
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Tcolors.title_color,
        iconTheme:
            const IconThemeData(color: Colors.white), // ✅ Make back icon white
      ),
      body: _isPermissionGranted
          ? Stack(
              children: [
                MobileScanner(
                    controller: MobileScannerController(
                      facing: CameraFacing.back,
                      torchEnabled: false,
                    ),
                    onDetect: (capture) async {
                      if (_hasScanned) return;

                      final barcode = capture.barcodes.first;
                      final String? code = barcode.rawValue;

                      if (code != null && !_hasScanned) {
                        if (code.startsWith("GRIP-")) {
                          setState(() => _hasScanned = true);
                          print('✅ Valid QR Code Scanned: $code');

                          // Optional: show a short success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Scanned: $code')),
                          );

                          // Delay before navigating (e.g., allow animation/message to show)
                          await Future.delayed(Duration(seconds: 1));

                          // ✅ Navigate to AttendanceSuccessPage
                          if (context.mounted) {
                            context.push('/AttendanceSuccess');
                          }
                        } else {
                          print('❌ Invalid QR Code: $code');

                          // ❌ Navigate to your error or failure page
                          if (context.mounted) {
                            context.push('/AttendanceFailure');
                          }
                        }
                      }
                    }),

                // 🔳 Custom Overlay Box for QR Area
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                // 🔲 Semi-transparent dark overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: ScannerOverlayPainter(scanAreaSize: 250),
                    ),
                  ),
                ),

                // 🔤 Instructional Text
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
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

    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw the background with a transparent "cut-out" area
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectXY(cutOutRect, 16, 16)),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
