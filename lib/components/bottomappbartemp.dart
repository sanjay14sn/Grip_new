import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class CurvedBottomNavBar extends StatelessWidget {
  const CurvedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Curved background with top corners rounded
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 10.h),
              painter: NavBarCustomPainter(),
            ),
          ),

          // Floating Scan Button
          Positioned(
            top: -3.h,
            child: GestureDetector(
              onTap: () => context.push('/QRscanner'),
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2C2B2B),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.white, size: 8.w),
                    Text(
                      'Scan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nav bar buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BottomBarButton(
                    onTap: () => context.push('/meeting'),
                    icon: Icons.people,
                    label: 'Meeting',
                  ),
                  _BottomBarButton(
                    onTap: () => context.push('/ChapterDetails'),
                    icon: Icons.groups,
                    label: 'Chapters',
                  ),
                  SizedBox(width: 16.w), // Leave space for the center button
                  _BottomBarButton(
                    onTap: () => context.push('/Event'),
                    icon: Icons.event,
                    label: 'Events',
                  ),
                  _BottomBarButton(
                    onTap: () => context.push('/Registration'),
                    icon: Icons.credit_card,
                    label: 'Registration',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const _BottomBarButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 7.w),
          SizedBox(height: 0.3.h), // Reduced spacing
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C2B2B) // DO NOT CHANGE
      ..style = PaintingStyle.fill;

    final path = Path();

    final center = size.width / 2;
    final notchRadius = 36.0;
    final notchDepth = 28.0;

    path.moveTo(0, 0);
    path.lineTo(center - notchRadius - 12, 0);

    // Left curve into notch
    path.quadraticBezierTo(
      center - notchRadius,
      0,
      center - notchRadius + 6,
      notchDepth / 2,
    );

    // Notch semi-circle
    path.arcToPoint(
      Offset(center + notchRadius - 6, notchDepth / 2),
      radius: Radius.circular(36),
      clockwise: false,
    );

    // Right curve out of notch
    path.quadraticBezierTo(
      center + notchRadius,
      0,
      center + notchRadius + 12,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
