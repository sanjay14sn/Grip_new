import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../backend/api-requests/no_auth_api.dart';

class MeetingDetailsPage extends StatelessWidget {
  const MeetingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: FutureBuilder(
        future: PublicRoutesApiService.fetchUpcomingMeetings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _shimmerUI();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Something went wrong"));
          }

          final response = snapshot.data!;
          final bool hasData = response.isSuccess &&
              response.data != null &&
              response.data is List &&
              response.data.isNotEmpty;

          if (!hasData) {
            return Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                height: 34.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  "No Upcoming Meetings Found",
                  style: TTextStyles.myprofile.copyWith(color: Colors.black54),
                ),
              ),
            );
          }

          final List meetings = response.data as List;
          final meeting = meetings[0];

          final startDate = DateTime.parse(meeting['startDate']).toLocal();
          final endDate = DateTime.parse(meeting['endDate']).toLocal();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              Center(
                child: Image.asset(
                  'assets/images/meeting_appbar.png',
                  color: const Color(0xFFC6221A),
                  width: 10.w,
                  height: 10.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text('Next Meeting', style: TTextStyles.nxtmeet),
              ),
              _meetingDetailsUI(
                topic: meeting['topic'],
                startDate: startDate,
                endDate: endDate,
                address: meeting['address'],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text('Your Attendance', style: TTextStyles.nxtmeet),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    attendanceCard('23', 'Present', Colors.green),
                    attendanceCard('5', 'Late', const Color(0xFFB07DFF)),
                    attendanceCard('2', 'Substitute', const Color(0xFF00BFA5)),
                    attendanceCard('1', 'Medical', const Color(0xFFFFAB00)),
                    attendanceCard('8', 'Absent', Colors.red),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(height: 2.h),
            ],
          );
        },
      )),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0E2E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          SizedBox(width: 4.w),
          Text('Meeting Details', style: TTextStyles.myprofile),
        ],
      ),
    );
  }

  Widget _meetingDetailsUI({
    required String topic,
    required DateTime startDate,
    required DateTime endDate,
    required String address,
  }) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.w),
            child: Image.asset(
              'assets/images/meeting.jpg',
              height: 39.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    meetingDetail('Topic:', topic),
                    meetingDetail('Date:', _formatDate(startDate)),
                    meetingDetail('Start Time:', _formatTime(startDate)),
                    meetingDetail('End Time:', _formatTime(endDate)),
                    meetingDetail('Venue:', address),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget meetingDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Container(
        width: 90.w,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: '$title ', style: TTextStyles.myprofile),
              TextSpan(text: value, style: TTextStyles.nxtmeet),
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(String count, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  Widget _shimmerUI() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5.h,
            width: 40.w,
            color: Colors.grey[300],
          ),
          SizedBox(height: 2.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              height: 34.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4.w),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 3.h,
            width: 30.w,
            color: Colors.grey[300],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              return Container(
                height: 6.h,
                width: 12.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.w),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
