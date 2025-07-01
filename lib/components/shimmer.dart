import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';


/// Shimmer Grid for general members
Widget buildShimmerGrid({int itemCount = 6}) {
  return GridView.builder(
    itemCount: itemCount,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(vertical: 1.h),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 3.w,
      childAspectRatio: 0.85,
    ),
    itemBuilder: (context, index) => _shimmerCard(),
  );
}

/// General shimmer card
Widget _shimmerCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 14.w,
            height: 14.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(height: 0.5.h),
          Container(
            height: 10,
            width: 30.w,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}

/// Shimmer for CID Member (slightly different sizing if needed)
Widget buildCidShimmer() {
  return GridView.builder(
    itemCount: 1,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(vertical: 1.h),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 3.w,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) => _shimmerCard(),
  );
}

/// Shimmer Search Bar
Widget buildSearchBarShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            height: 12,
            width: 60.w,
            color: Colors.grey,
          )
        ],
      ),
    ),
  );
}

/// Shimmer for All Members Title
Widget buildAllMembersTitleShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 73.w,
      height: 3.3.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Color(0xFF2C2B2B),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Container(
        height: 12,
        width: 30.w,
        color: Colors.grey[400],
      ),
    ),
  );
}

/// Shimmer for Search Bar (matches _buildSearchBar style)
Widget buildSearchBarExactShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            height: 14,
            width: 60.w,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
//testimomials

Widget buildShimmerList() {
  return ListView.builder(
    itemCount: 9,
    itemBuilder: (context, index) {
      return Card(
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
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
