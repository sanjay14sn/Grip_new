import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class CurvedBottomNavBar extends StatelessWidget {
  const CurvedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Curved background bar
          Container(
            height: 9.h,
            decoration: BoxDecoration(
        color:       const Color(0xFF2C2B2B), // Rich dark gray
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomBarButton(
                  onTap: () => context.push('/ChapterDetails'),
                  icon:
                      Icon(Icons.groups, color: Color(0xFFC6221A), size: 6.5.w),
                  label: 'Chapter\nDetails',
                ),
                SizedBox(width: 60), // Space for central button
                _BottomBarButton(
                  onTap: () => context.push('/meeting'),
                  icon: Image.asset(
                    'assets/images/meeting_appbar.png',
                    color: Color(0xFFC6221A),
                    width: 6.5.w,
                    height: 6.5.w,
                  ),
                  label: 'Meeting',
                ),
              ],
            ),
          ),

          // Floating Home Button
          Positioned(
            top: -2.5.h,
            child: GestureDetector(
              onTap: () {
                context.push('/QRscanner'); // Set your scan route
              },
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFE3E3E3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2_rounded,
                        color: Color(0xFFC83837), size: 9.w),
                    SizedBox(height: 1),
                    Text(
                      'Scan',
                      style: TextStyle(
                        color: Color(0xFFC83837),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
  final Widget icon;
  final String label;

  const _BottomBarButton({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 5.2.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFD6E0E1),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: icon,
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: TTextStyles.bottombartext,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
