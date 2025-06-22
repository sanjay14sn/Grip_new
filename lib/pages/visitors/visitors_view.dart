import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class VisitorsViewpage extends StatelessWidget {
  final List<dynamic> visitors;

  const VisitorsViewpage({super.key, required this.visitors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Text('Visitors Invited by Me', style: TTextStyles.Editprofile),
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Dismiss",
                        barrierColor: Colors.transparent,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (_, __, ___) {
                          return Stack(
                            children: [
                              Positioned(
                                top: 60,
                                right: 16,
                                child: Material(
                                  color: Colors.transparent,
                                  child: FilterDialog(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.filter_alt_outlined,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // 👥 Title row
              Row(
                children: [
                  Text('Visitors', style: TTextStyles.Editprofile),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/handshake.png',
                    width: 34,
                    height: 34,
                  )
                ],
              ),

              SizedBox(height: 2.h),

              // 📋 Visitor List
              Expanded(
                child: visitors.isEmpty
                    ? const Center(child: Text('No visitors found.'))
                    : ListView.builder(
                        itemCount: visitors.length,
                        itemBuilder: (context, index) {
                          final visitor = visitors[index];
                          final name = visitor['name'] ?? 'Unknown';
                          final visitDate = visitor['visitDate'] ?? '';
                          final formattedDate =
                              visitDate.toString().substring(0, 10);

                          return referralTile(
                            context,
                            visitor,
                            name,
                            formattedDate,
                            'assets/images/profile1.jpg',
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Fix: Pass `visitor` as an argument
  Widget referralTile(BuildContext context, Map<String, dynamic> visitor,
      String name, String date, String imagePath) {
    return GestureDetector(
      onTap: () {
        context.push('/visiteddetails', extra: visitor);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 2.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
