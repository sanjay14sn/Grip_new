import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/utils/theme/Textheme.dart';

class OthersVisitorsPage extends StatefulWidget {
  const OthersVisitorsPage({super.key});

  @override
  State<OthersVisitorsPage> createState() => _OthersVisitorsPageState();
}

class _OthersVisitorsPageState extends State<OthersVisitorsPage> {
  final List<Map<String, String>> givenVisitors = [
    {
      'name': 'John Doe',
      'date': '2024-06-15',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'name': 'Jane Smith',
      'date': '2024-06-20',
      'image': 'https://via.placeholder.com/150'
    },
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Text('Visitors Invited by Me',
                      style: TTextStyles.Editprofile),
                  const SizedBox(width: 40), // placeholder space for symmetry
                ],
              ),

              SizedBox(height: 2.h),

              // 👥 Section title
              Row(
                children: [
                  Text('Visitors', style: TTextStyles.Editprofile),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/handshake.png',
                    width: 34,
                    height: 34,
                  )
                ],
              ),

              SizedBox(height: 2.h),

              // 📋 Visitor list
              Expanded(
                child: givenVisitors.isEmpty
                    ? const Center(child: Text('No visitors found.'))
                    : ListView.builder(
                        itemCount: givenVisitors.length,
                        itemBuilder: (context, index) {
                          final visitor = givenVisitors[index];
                          final name = visitor['name'] ?? 'Unknown';
                          final dateStr = visitor['date'];
                          final formattedDate = dateStr != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  DateTime.tryParse(dateStr) ??
                                      DateTime.now())
                              : '';

                          return visitorTile(
                              context, name, formattedDate, visitor['image']);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget visitorTile(BuildContext context, String name, String date, String? imageUrl) {
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
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null ? const Icon(Icons.person) : null,
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
