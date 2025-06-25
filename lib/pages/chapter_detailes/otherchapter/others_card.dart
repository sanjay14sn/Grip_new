import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class othersMemberCard extends StatelessWidget {
  final othersMemberModel member; // ✅ FIXED: Correct model class
  const othersMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.push('/Chaptermember');
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 33.w,
          height: 11.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/profile.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Text(member.name,
                          textAlign: TextAlign.center,
                          style: TTextStyles.membername),
                      Text(member.company,
                          textAlign: TextAlign.center,
                          style: TTextStyles.membercard),
                      if (member.phone.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 0.8.h),
                          child: Text(
                            "📞 ${member.phone}",
                            style: TTextStyles.membercard,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Optional: show role
              // if (member.role != null && member.role!.isNotEmpty)
              //   Container(
              //     width: double.infinity,
              //     height: 3.h,
              //     decoration: const BoxDecoration(
              //       color: Tcolors.smalll_button,
              //       borderRadius: BorderRadius.vertical(
              //         bottom: Radius.circular(10),
              //       ),
              //     ),
              //     alignment: Alignment.center,
              //     child: Text(member.role!,
              //         textAlign: TextAlign.center,
              //         style: TTextStyles.chapterrole),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
