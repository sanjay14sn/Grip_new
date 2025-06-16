import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFC6221A),
            title: Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(4.w),
            child: ListView(
              children: [
                const EventCard(
                  title: 'Womens Day Celebration',
                  date: '10-15-2025',
                  time: '7:30 AM',
                  location: 'Royal Palace, T Nagar',
                  imageUrl:
                      'https://images.pexels.com/photos/3184394/pexels-photo-3184394.jpeg',
                ),
                SizedBox(height: 2.h),
                const EventCard(
                  title: 'Mega Visitor Day',
                  date: '10-15-2025',
                  time: '7:30 AM',
                  location: 'Royal Palace, T Nagar',
                  imageUrl:
                      'https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final String imageUrl;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with title overlay
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  imageUrl,
                  height: 20.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Event details
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
