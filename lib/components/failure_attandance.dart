import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class AttendanceFailurePage extends StatelessWidget {
  const AttendanceFailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 20.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E2E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Attendance',
          style: TTextStyles.Attendancehead,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                ),
                Icon(
                  Icons.cancel,
                  size: 30.w,
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: 28.w,
              height: 1.5.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Scan Unsuccessful',
              style: TTextStyles.Scan,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Column(
                children: [
                  Text(
                    'The Code You Scanned Is Not\nValid For Attendance.',
                    style: TTextStyles.youratt.copyWith(fontSize: 11.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '(Or)',
                    style: TTextStyles.youratt.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Make Sure The QR Code Is Clear\nAnd Within The Frame.',
                    style: TTextStyles.youratt.copyWith(fontSize: 11.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A3A3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TTextStyles.attDone,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
