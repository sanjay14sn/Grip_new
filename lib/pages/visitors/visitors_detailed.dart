import 'package:flutter/material.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Visitors Invited By Me"),
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Icon(Icons.remove_red_eye_outlined,
                        size: 30, color: Colors.black54)),
                const SizedBox(height: 16),
                _buildLabelValue("Name", visitor['name'] ?? '-'),
                _buildLabelValue("Company", visitor['company'] ?? '-'),
                _buildLabelValue("Category", visitor['category'] ?? '-'),
                _buildLabelValueWithIcon("Mobile", visitor['mobile'] ?? '-',
                    Icons.phone, Colors.red),
                _buildLabelValue("Email", visitor['email'] ?? '-'),
                _buildLabelValueWithIcon("Address", visitor['address'] ?? '-',
                    Icons.location_on, Colors.red),
                //_buildLabelValue("Comments", visitor['comments'] ?? '-'),
                _buildLabelValueWithIcon(
                  "Visit Date",
                  visitor['visitDate']?.toString().substring(0, 10) ?? '-',
                  Icons.calendar_today,
                  Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
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
          Text("$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
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
                    child: Text(value,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.red))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
