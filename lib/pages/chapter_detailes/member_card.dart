import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/gorouter.dart';
import 'package:grip/pages/chapter_detailes/chapterdetails.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  const MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final isRoleCard = member.role.isNotEmpty;

    return Material(
      child: InkWell(
        onTap: () {
          context.push('/Chaptermember');
        },
        borderRadius: BorderRadius.circular(10), // match card shape
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
                          image: DecorationImage(
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
                      if (!isRoleCard && member.phone != null)
                        Padding(
                          padding: EdgeInsets.only(top: 0.8.h),
                          child: Text(
                            "📞 ${member.phone!}",
                            style: TTextStyles.membercard,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isRoleCard)
                Container(
                  width: double.infinity,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: Tcolors.title_color,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(member.role,
                      textAlign: TextAlign.center,
                      style: TTextStyles.chapterrole),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
