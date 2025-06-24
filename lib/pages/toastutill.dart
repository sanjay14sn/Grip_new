import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToastUtil {
  static void showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 2.h,
        left: 4.w,
        right: 4.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: const Color(0xFF006D41), // Green background
              borderRadius: BorderRadius.circular(2.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 6.w),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => overlayEntry.remove(),
                  child: Icon(Icons.close, color: Colors.white, size: 5.w),
                )
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
class UrlService {
  static const String IMAGE_BASE_URL = " https://api.grip.oceansoft.online/api/public";
}