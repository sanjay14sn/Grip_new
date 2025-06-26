import 'package:flutter/material.dart';

Widget shimmerBox({double height = 20, double width = double.infinity, double radius = 8}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

Widget buildShimmerCard() {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: 20, width: 100),
        SizedBox(height: 12),
        Row(
          children: [
            shimmerBox(height: 60, width: 60, radius: 12),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(height: 14, width: double.infinity),
                  SizedBox(height: 8),
                  shimmerBox(height: 14, width: 150),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget buildShimmerProfileRow() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(height: 16, width: 120),
            SizedBox(height: 8),
            shimmerBox(height: 12, width: 200),
          ],
        ),
      ),
      CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
      SizedBox(width: 8),
      CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
    ],
  );
}
