import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final bool isRoleCard = member.role != null && member.role!.isNotEmpty;

    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          context.push('/Chaptermember', extra: member);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 33.w,
          height: isRoleCard ? 19.h : 14.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 10.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: (member.profileImageUrl != null &&
                                    member.profileImageUrl!.isNotEmpty)
                                ? NetworkImage(member.profileImageUrl!)
                                : const AssetImage("assets/images/profile.png")
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        member.name,
                        textAlign: TextAlign.center,
                        style: TTextStyles.membername,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        member.company,
                        textAlign: TextAlign.center,
                        style: TTextStyles.membercard,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          "📞 ${member.phone}",
                          style: TTextStyles.membercard,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isRoleCard)
                Container(
                  width: double.infinity,
                  height: 3.3.h,
                  decoration: const BoxDecoration(
                    color: Tcolors.smalll_button,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    member.role!,
                    style: TTextStyles.chapterrole,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
