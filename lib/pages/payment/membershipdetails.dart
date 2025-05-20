import 'package:flutter/material.dart';
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
          style: TextStyle(color: Colors.red, fontSize: 13.sp),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 18.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            CircleAvatar(
              radius: 7.h,
              backgroundImage: NetworkImage(
                  'https://example.com/avatar.jpg'), // Replace with actual URL
            ),
            SizedBox(height: 1.5.h),
            Text(
              'Dinesh Kumar',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'GRIP ARAM',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp),
            ),
            SizedBox(height: 4.h),
            _buildInfoRow("Amount", "₹ 1,500"),
            divider(),
            _buildInfoRow("Subscription Plan", "Yearly Plan"),
            divider(),
            _buildInfoRow("Status", "Active"),
            divider(),
            _buildInfoRow("Start Date", "October 21, 2025"),
            divider(),
            _buildInfoRow("Expiry Date", "October 21, 2026"),
            divider(),
            const Spacer(),
            SizedBox(
              width: 30.w,
              height: 5.h,
              child: OutlinedButton(
                onPressed: () {
                  // Renew logic
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Renew",
                  style: TextStyle(color: Colors.red, fontSize: 11.sp),
                ),
              ),
            ),
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
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11.sp),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11.sp,
                color: label == "Status" ? Colors.green : Colors.black,
              ),
            ),
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
