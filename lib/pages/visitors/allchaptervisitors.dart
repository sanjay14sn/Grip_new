import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class AllVisitorsViewpage extends StatefulWidget {
  final List<Map<String, dynamic>> allVisitors;

  const AllVisitorsViewpage({super.key, required this.allVisitors});

  @override
  State<AllVisitorsViewpage> createState() => _AllVisitorsViewpageState();
}

class _AllVisitorsViewpageState extends State<AllVisitorsViewpage> {
  late List<Map<String, dynamic>> visitors;

  @override
  void initState() {
    super.initState();
    visitors = widget.allVisitors;
  }

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
                children: [
                  // 🔙 Back Button
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

                  // 🪪 Centered Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'All Visitors - 7 Days',
                        style: TTextStyles.Editprofile,
                      ),
                    ),
                  ),

                  // 🔳 Empty box to balance the back button
                  SizedBox(width: 40), // Same width as the back button area
                ],
              ),

              SizedBox(height: 2.h),

              // 👥 Title
              Row(
                children: [
                  Text('Visitors', style: TTextStyles.Editprofile),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/handshake.png',
                      width: 34, height: 34),
                ],
              ),

              SizedBox(height: 2.h),

              // 📋 Visitor List
              Expanded(
                child: visitors.isEmpty
                    ? const Center(child: Text('No visitors found.'))
                    : ListView.builder(
                        itemCount: visitors.length,
                        itemBuilder: (context, index) {
                          final visitor = widget.allVisitors[index];
                          final name = visitor['name'] ?? 'Unknown';
                          final invitedByName = visitor['invitedBy']?['name'] ??
                              'Unknown inviter';
                          final dateStr = visitor['visitDate']?.toString();
                          final formattedDate = dateStr != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  DateTime.tryParse(dateStr) ?? DateTime.now())
                              : '';

                          return referralTile(
                            visitor,
                            invitedByName,
                            formattedDate,
                            'assets/images/profile.png',
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

  Widget referralTile(Map<String, dynamic> visitor, String invitedByName,
      String date, String imagePath) {
    return GestureDetector(
      onTap: () => context.push(
        '/visiteddetails',
        extra: {
          'visitor': visitor,
          'hideSensitiveFields': true,
        },
      ),
      child: Card(
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
              CircleAvatar(radius: 20, backgroundImage: AssetImage(imagePath),backgroundColor: Colors.white,),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Invited By: ",
                          style: TextStyle(
                            color: Color(0xFFC6221A),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: invitedByName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
