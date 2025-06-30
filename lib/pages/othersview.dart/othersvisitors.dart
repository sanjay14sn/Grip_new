import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OthersVisitorsPage extends StatefulWidget {
  const OthersVisitorsPage({super.key});

  @override
  State<OthersVisitorsPage> createState() => _OthersVisitorsPageState();
}

class _OthersVisitorsPageState extends State<OthersVisitorsPage> {
  List<dynamic> visitors = [];
  bool isLoading = true;
  String? memberId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    memberId = GoRouterState.of(context).extra as String?;
    if (memberId != null) {
      _loadVisitorsByMember(memberId!);
    }
  }

  Future<void> _loadVisitorsByMember(String id) async {
    final response = await PublicRoutesApiService.fetchVisitorsByMember(id);

    if (response.isSuccess) {
      setState(() {
        visitors = response.data ?? [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to fetch visitors')),
      );
    }
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
              // Header
              Row(
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
                  Expanded(
                    child: Center(
                      child: Text('Visitors Invited',
                          style: TTextStyles.Editprofile),
                    ),
                  ),
                  const SizedBox(width: 40), // placeholder
                ],
              ),
              SizedBox(height: 2.h),

              Row(
                children: [
                  Text('Visitors', style: TTextStyles.Editprofile),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/handshake.png',
                      width: 34, height: 34),
                ],
              ),
              SizedBox(height: 2.h),

              // List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : visitors.isEmpty
                        ? const Center(child: Text('No visitors found.'))
                        : ListView.builder(
                            itemCount: visitors.length,
                            itemBuilder: (context, index) {
                              final visitor = visitors[index];
                              final name = visitor['name'] ?? 'Unknown';
                              final dateStr = visitor['visitDate'];
                              final formattedDate = dateStr != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      DateTime.tryParse(dateStr) ??
                                          DateTime.now())
                                  : '';
                              return visitorTile(
                                context,
                                name,
                                formattedDate,
                                'assets/images/profile.png',
                                visitor,
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

  Widget visitorTile(BuildContext context, String name, String date,
      String imagePath, Map<String, dynamic> visitor) {
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
              CircleAvatar(radius: 20, backgroundImage: AssetImage(imagePath)),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      )),
                  Text(date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      )),
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
