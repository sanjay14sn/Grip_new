import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/constants/Tcolors.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  List<AgentaEvent> _events = [];
  bool _isLoading = true; // Start with loading

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Fetch events from the API
  Future<void> _fetchEvents() async {
    const storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');

    if (userDataString == null) {
      setState(() => _isLoading = false);
      ToastUtil.showToast(context, 'User not logged in');
      return;
    }

    final userData = jsonDecode(userDataString);
    final userChapterId = userData['chapterId'];

    final response = await PublicRoutesApiService.fetchAgentaEvents();

    if (mounted) {
      if (response.isSuccess && response.data is List) {
        final filteredEvents = (response.data as List)
            .where((e) {
              final chapterIds = e['chapterId'] as List<dynamic>? ?? [];
              return chapterIds.any((c) => c['_id'] == userChapterId);
            })
            .map((e) => AgentaEvent.fromJson(e))
            .toList();

        setState(() {
          _events = filteredEvents;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ToastUtil.showToast(
            context, response.message ?? 'Failed to load events');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Tcolors.title_color,
            title: Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: _isLoading
              ? ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: 5, // Show 5 shimmer cards
                  itemBuilder: (_, __) => const ShimmerCard(),
                )
              : _events.isEmpty
                  ? const Center(child: Text('No upcoming events'))
                  : ListView.separated(
                      padding: EdgeInsets.all(4.w),
                      itemCount: _events.length,
                      separatorBuilder: (_, __) => SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return EventCard(
                          title: event.topic,
                          date:
                              '${event.date.day}-${event.date.month}-${event.date.year}',
                          time:
                              '${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}',
                          location: event.address,
                          imageUrl: event.imageUrl,
                        );
                      },
                    ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 20.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 80,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Container(
                        height: 14,
                        width: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final String? imageUrl;

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
          // Image with overlay title
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        height: 20.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _noImageFallback(title),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _shimmerImagePlaceholder();
                        },
                      )
                    : _noImageFallback(title),

                // Title overlay
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Text(
                      date,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black87),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Text(
                      time,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.black54),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        location,
                        style:
                            TextStyle(fontSize: 11.sp, color: Colors.black87),
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

  // Shimmer placeholder while image loads
  Widget _shimmerImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 20.h,
        width: double.infinity,
        color: Colors.grey[300],
      ),
    );
  }

  // Fallback with centered title if no image
  Widget _noImageFallback(String title) {
    return Container(
      height: 20.h,
      width: double.infinity,
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}

// Helper method to create shimmer for image loading
Widget _shimmerImagePlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 20.h,
      width: double.infinity,
      color: Colors.grey[300],
    ),
  );
}

class AgentaEvent {
  final String id;
  final String topic;
  final String? imageUrl;
  final String address;
  final DateTime date;

  AgentaEvent({
    required this.id,
    required this.topic,
    required this.imageUrl,
    required this.address,
    required this.date,
  });

  factory AgentaEvent.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    String? imageUrl;

    if (image is Map<String, dynamic> &&
        image['docPath'] != null &&
        image['docName'] != null) {
      imageUrl =
          "${UrlService.imageBaseUrl}/${image['docPath']}/${image['docName']}";
    }

    return AgentaEvent(
      id: json['_id'],
      topic: json['topic'],
      imageUrl: imageUrl,
      address: json['address'] ?? 'No location',
      date: DateTime.parse(json['date']),
    );
  }
}
