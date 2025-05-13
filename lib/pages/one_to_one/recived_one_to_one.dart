import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OneToOneDetailsPage extends StatelessWidget {
  final List<Map<String, String>> meetings = [
    {
      'name': 'Paul Mauray',
      'date': '12 Nov 2024',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Dinesh',
      'date': '12 Nov 2024',
      'image': 'assets/images/profile2.jpg',
    },
    {
      'name': 'Amaran',
      'date': '15 Nov 2024',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Babu',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile3.jpg',
    },
    {
      'name': 'Velu',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile4.jpg',
    },
    {
      'name': 'Dinesh',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile3.jpg',
    },
    {
      'name': 'Amaran',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile1.jpg',
    },
    {
      'name': 'Babu',
      'date': '17 Nov 2024',
      'image': 'assets/images/profile2.jpg',
    },
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
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E2E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "ONE TO ONES DETAILS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Icon(Icons.filter_alt_outlined),
                ],
              ),
              SizedBox(height: 2.h),

              // Profile Image & Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          AssetImage('assets/images/profile1.jpg'),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Balu.M",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "GRIP ARAM",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // Meetings List
              Expanded(
                child: ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (context, index) {
                    final item = meetings[index];
                    return Card(
                      elevation: 1,
                      margin:
                          EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item['image']!),
                          radius: 22,
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "MET WITH: ",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: item['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          item['date']!,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: Colors.red),
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
