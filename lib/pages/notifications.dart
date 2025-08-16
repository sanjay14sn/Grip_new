import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';
import 'package:grip/backend/api-requests/imageurl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    timeago.setDefaultLocale('en');
    fetchNotificationList();
  }

  Future<void> fetchNotificationList({int retries = 2}) async {
    try {
      final response = await PublicRoutesApiService.fetchNotifications();
      if (response.isSuccess) {
        setState(() {
          notifications = response.data;
          isLoading = false;
        });
      } else {
        if (retries > 0) {
          await Future.delayed(const Duration(seconds: 1));
          return fetchNotificationList(retries: retries - 1);
        } else {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      if (retries > 0) {
        await Future.delayed(const Duration(seconds: 1));
        return fetchNotificationList(retries: retries - 1);
      } else {
        setState(() => isLoading = false);
      }
    }
  }

  String getNotificationMessage(String type) {
    switch (type) {
      case 'referral':
        return 'sent you a Referral Note.';
      case 'thankyou':
        return 'sent you a Thank You Note.';
      case 'testimonial':
        return 'sent you a Testimonial.';
      default:
        return 'sent you a notification.';
    }
  }

  Widget _buildShimmerLoader() {
    return Expanded(
      child: ListView.builder(
        itemCount: 9,
        padding: EdgeInsets.only(bottom: 1.h),
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          width: 40.w,
                          color: Colors.white,
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          height: 10,
                          width: 25.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Row(
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
                  Text('Notifications', style: TTextStyles.ReferralSlip),
                ],
              ),
              SizedBox(height: 2.h),
              isLoading
                  ? _buildShimmerLoader()
                  : Expanded(
                      child: notifications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('No notifications found'),
                                  SizedBox(height: 2.h),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: notifications.length,
                              padding: EdgeInsets.only(bottom: 1.h),
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                final from = notification['fromMember'] ?? {};
                                final personalDetails =
                                    from['personalDetails'] ?? {};

                                final firstName =
                                    personalDetails['firstName'] ?? 'Unknown';
                                final lastName =
                                    personalDetails['lastName'] ?? '';
                                final name = '$firstName $lastName';

                                final type = notification['type'];
                                final message = getNotificationMessage(type);

                                final createdAt = DateTime.tryParse(
                                        notification['createdAt'] ?? '') ??
                                    DateTime.now();
                                final formattedTime = timeago.format(createdAt);

                                final profileImage =
                                    personalDetails['profileImage'];
                                final imageUrl = (profileImage != null &&
                                        profileImage['docPath'] != null &&
                                        profileImage['docName'] != null)
                                    ? "${UrlService.imageBaseUrl}/${profileImage['docPath']}/${profileImage['docName']}"
                                    : null;

                                return Container(
                                  margin: EdgeInsets.only(bottom: 1.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage(
                                                  'assets/images/profile.png')
                                              as ImageProvider,
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '$name ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: message,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      formattedTime,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    onTap: () {},
                                  ),
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
}
