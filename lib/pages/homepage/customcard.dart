import 'package:flutter/material.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/constants/Timages.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class Customcard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTapAddView;
  final VoidCallback onTapView;
  final String imagePath;

  const Customcard({
    super.key,
    required this.title,
    required this.value,
    required this.onTapAddView,
    required this.onTapView,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    bool isAddOnly = title.toLowerCase() == "visitor";

    return Card(
      elevation: 3,
      // color: Tcolors.homecard,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 14.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 26),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: TTextStyles.bodycontentsmall),
                  const SizedBox(height: 4),
                  Text(value, style: TTextStyles.usernametitle),
                  const SizedBox(height: 8),
                  isAddOnly
                      ? GestureDetector(
                          onTap: onTapAddView,
                          child: Container(
                            height: 3.h,
                            width: 30.w,
                            decoration: BoxDecoration(
                              gradient: Tcolors.red_button,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Center(
                              child: Text(
                                "Add New",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onTapAddView,
                              child: Container(
                                height: 3.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Tcolors.smalll_button,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Add New",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: onTapView,
                              child: Container(
                                height: 3.h,
                                width: 27.w,
                                decoration: BoxDecoration(
                                  color: Tcolors.smalll_button,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: const Center(
                                  child: Text(
                                    "View",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
