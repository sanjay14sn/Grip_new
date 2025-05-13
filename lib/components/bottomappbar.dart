import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/gorouter.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 9.h, // ~72px on a 800px height screen
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
          // Home Button
          Container(
            width: 28.w, // Approx. 112px on 400px wide screen
            height: 5.2.h, // Approx. 41px on 800px high screen
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
              onPressed: () {
                context.push('/ChapterDetails');
              },
              icon: Icon(Icons.groups, color: Colors.blueAccent, size: 6.5.w),
              label: Text(
                'Chapter\nDetails',
                style: TTextStyles.bottombartext,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const StadiumBorder(),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

          // Chapter Details Button
          Container(
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
              onPressed: () {
                context.push('/meeting');
              },
              icon: Image.asset(
                'assets/images/meeting_appbar.png', // Replace with your image path
                width: 6.5.w, // Keep size consistent with what Icon was using
                height: 6.5.w,
              ),
              label: Text(
                'Meeting',
                style: TTextStyles.bottombartext,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const StadiumBorder(),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
