import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class MembershipDetailsPage extends StatefulWidget {
  const MembershipDetailsPage({super.key});

  @override
  State<MembershipDetailsPage> createState() => _MembershipDetailsPageState();
}

class _MembershipDetailsPageState extends State<MembershipDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Membership Details',
          style: TTextStyles.ReferralSlip,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 50, // ⬅️ Make room for a smaller leading
        leading: Padding(
          padding: const EdgeInsets.only(left: 12), // ⬅️ Push it slightly right
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Go back
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E2E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 18, // ⬅️ Smaller icon
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile + Membership Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              margin: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 7.h,
                    backgroundImage:
                        NetworkImage('https://example.com/avatar.jpg'),
                  ),
                  SizedBox(height: 1.5.h),
                  Text('Dinesh Kumar', style: TTextStyles.ProfileName),
                  Text('GRIP ARAM', style: TTextStyles.gripname),
                  SizedBox(height: 3.5.h),
                  _buildInfoRow("Amount", "₹ 1,500"),
                  divider(),
                  _buildInfoRow("Subscription Plan", "Yearly Plan"),
                  divider(),
                  _buildInfoRow("Status", "Active"),
                  divider(),
                  _buildInfoRow("Start Date", "October 21, 2025"),
                  divider(),
                  _buildInfoRow("Expiry Date", "October 21, 2026"),
                ],
              ),
            ),

            // Renew Button
            GestureDetector(
              onTap: () {
                //context.push('/membershipdetails');
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(1
                      .w), // Outer padding - controls thickness of gradient border
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E8DDB), Color(0xFFE14F4F)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      'RENEW',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF00BFA6), Color(0xFFE14F4F)],
                          ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TTextStyles.membership),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TTextStyles.membershipstatus),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 1, // 1px divider
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E8DDB), // Blue
            Color(0xFFE14F4F), // Red
          ],
        ),
      ),
    );
  }
}
