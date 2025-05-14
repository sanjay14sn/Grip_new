import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class AttendanceSuccessPage extends StatelessWidget {
  const AttendanceSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 20.w, // Makes room for padding
        leading: Padding(
          padding: EdgeInsets.only(left: 3.w), // Move button right
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
                // Outer circle
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF4BA52F), width: 2),
                  ),
                ),
                // Check icon
                Icon(
                  Icons.check_circle,
                  size: 36.w,
                  color: Color(0xFF4BA52F),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Ellipse under the circle
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
              'Scan Succeeded',
              style: TTextStyles.Scan,
            ),
            SizedBox(height: 1.h),
            Text(
              'Your Attendance Marked',
              style: TTextStyles.youratt,
            ),
            SizedBox(height: 1.5.h),
            Container(
              width: 70.w,
              height: 1,
              color: Colors.grey[300],
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/homepage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
                child: Text(
                  'Done',
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
