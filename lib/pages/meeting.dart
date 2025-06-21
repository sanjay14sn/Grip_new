import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/backend/providers/chapter_provider.dart';

class MeetingDetailsPage extends StatelessWidget {
  const MeetingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ChapterProvider>(
          builder: (context, provider, _) {
            final details = provider.chapterDetails;

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (details == null) {
              return const Center(child: Text("No Meeting Data Found"));
            }

            // Extract date and time
            final dateStr = details.meetingDayAndTime.split(' ')[0] +
                ', ' +
                details.meetingDayAndTime.split(' ')[2] +
                ' ' +
                details.meetingDayAndTime.split(' ')[1] +
                ' ' +
                details.meetingDayAndTime.split(' ')[3];
            final timeStr = details.meetingDayAndTime.split(' ')[4];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E2E7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text('Meeting Details', style: TTextStyles.myprofile),
                    ],
                  ),
                ),

                // Section Title
                Center(
                  child: Image.asset(
                    'assets/images/meeting_appbar.png',
                    color: Color(0xFFC6221A),
                    width: 10.w,
                    height: 10.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text('Next Meeting', style: TTextStyles.nxtmeet),
                ),

                // Image & Meeting Info
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.w),
                        child: Image.asset(
                          'assets/images/meeting.jpg',
                          height: 34.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 34.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              meetingDetail('Date:', dateStr),
                              meetingDetail('Time:', timeStr),
                              meetingDetail('Mode:', details.meetingType),
                              meetingDetail('Location:', details.meetingVenue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text('Your Attendance', style: TTextStyles.nxtmeet),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      attendanceCard('23', 'Present', Colors.green),
                      attendanceCard('5', 'Late', Color(0xFFB07DFF)),
                      attendanceCard('8', 'Absent', Colors.red),
                    ],
                  ),
                ),

                const Spacer(),
                SizedBox(height: 2.h),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget meetingDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Container(
        width: 90.w,
        height: 6.5.h,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: TTextStyles.myprofile,
                ),
                TextSpan(
                  text: value,
                  style: TTextStyles.nxtmeet,
                ),
              ],
            ),
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
}
