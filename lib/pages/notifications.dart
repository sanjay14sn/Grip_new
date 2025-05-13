import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> notifications = [
    {
      'name': 'Karthik',
      'message': 'Sent You A Referral Note.',
      'time': '20 min ago',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A One -To - Ones Note.',
      'time': '50 min ago',
      'image': 'assets/images/profile2.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A Referral Note.',
      'time': '1 hours ago',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A Referral Note.',
      'time': '2 Days ago',
      'image': 'assets/images/profile3.jpg',
    },
    {
      'name': 'Karthik',
      'message': 'Sent You A Referral Note.',
      'time': '3 Days ago',
      'image': 'assets/images/profile4.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A One -To - Ones Note.',
      'time': '5 Days ago',
      'image': 'assets/images/profile5.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A Referral Note.',
      'time': '10 Days ago',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Murali',
      'message': 'Sent You A Referral Note.',
      'time': '10 Days ago',
      'image': 'assets/images/profile2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h), // <-- Add this line to push the header down

            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
              ],
            ),

            SizedBox(height: 2.h), // <-- Add this for vertical space

            Text(
              'Notifications',
              style: TTextStyles.ReferralSlip,
            ),

            // Notifications List
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(notification['image']!),
                      ),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${notification['name']} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: notification['message'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        notification['time']!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      onTap: () {
                        debugPrint('Tapped on ${notification['name']}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
