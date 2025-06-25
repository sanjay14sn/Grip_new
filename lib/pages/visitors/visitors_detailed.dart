import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, size: 7.w),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC6221A),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Text(
                          'RECEIVED TESTIMONIAL SLIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),

              SizedBox(height: 2.h),

              /// Visitor Details Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(Icons.remove_red_eye_outlined,
                            size: 30, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      _buildLabelValue("Name", visitor['name'] ?? '-'),
                      _buildLabelValue("Company", visitor['company'] ?? '-'),
                      _buildLabelValue("Category", visitor['category'] ?? '-'),
                      _buildLabelValueWithIcon(
                          "Mobile",
                          visitor['mobile'] ?? '-',
                          Icons.phone,
                          Color(0xFFC6221A)),
                      _buildLabelValue("Email", visitor['email'] ?? '-'),
                      _buildLabelValueWithIcon(
                          "Address",
                          visitor['address'] ?? '-',
                          Icons.location_on,
                          Color(0xFFC6221A)),
                      _buildLabelValueWithIcon(
                        "Visit Date",
                        visitor['visitDate']?.toString().substring(0, 10) ??
                            '-',
                        Icons.calendar_today,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueWithIcon(
      String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFFC6221A)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
