import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentScreen extends StatelessWidget {
  final List<PaymentItem> items = [
    PaymentItem("Hotel Registration", "assets/images/registration.png",
        Colors.blue, "15 June 2025"),
    PaymentItem("Training Registration", "assets/images/tropy.png",
        Colors.purple, "15 June 2025"),
    PaymentItem("Dinner Registration", "assets/images/dinning.png",
        Colors.orange, "15 June 2025"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC6221A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Payment",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.all(3.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final item = items[index];
              return PaymentCard(item: item);
            },
          ),
        ),
      ),
    );
  }
}

class PaymentItem {
  final String title;
  final String iconPath;
  final Color iconColor;
  final String date;
  PaymentItem(this.title, this.iconPath, this.iconColor, this.date);
}

class PaymentCard extends StatelessWidget {
  final PaymentItem item;

  const PaymentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: item.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Image.asset(item.iconPath,
                width: 10.w, height: 10.w, color: item.iconColor),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: 0.5.h),
                Text(item.date,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₹ 750",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.black)),
              SizedBox(height: 1.h),
              SizedBox(
                height: 3.h, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w), // No vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    "Pay Now",
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
