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
