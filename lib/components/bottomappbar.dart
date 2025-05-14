import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 9.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: const Color(0xFF59AFCB),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Chapter Details Button
          _BottomBarButton(
            onTap: () => context.push('/ChapterDetails'),
            icon: Icon(Icons.groups, color: Colors.blueAccent, size: 6.5.w),
            label: 'Chapter\nDetails',
          ),

          // Scan Circle Button
          GestureDetector(
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
                  Icon(Icons.qr_code_2_rounded, color: Color(0xFFC83837), size: 9.w),
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

          // Meeting Button
          _BottomBarButton(
            onTap: () => context.push('/meeting'),
            icon: Image.asset(
              'assets/images/meeting_appbar.png',
              width: 6.5.w,
              height: 6.5.w,
            ),
            label: 'Meeting',
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
