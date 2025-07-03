import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OthersOneToOnesPage extends StatelessWidget {
  final List<dynamic> othersList;

  const OthersOneToOnesPage({
    super.key,
    required this.othersList,
  });

  String _formatDate(String rawDate) {
    try {
      final dateTime = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    const imageBaseUrl =
        'https://your-server.com/uploads'; // 🔁 Set your actual base URL

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6221A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "ONE TO ONES DETAILS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.filter_alt_outlined),
                ],
              ),
              SizedBox(height: 2.h),

              // List or Empty State
              Expanded(
                child: othersList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty,
                                size: 50, color: Colors.grey.shade400),
                            SizedBox(height: 1.h),
                            const Text(
                              "No One-to-One found.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: othersList.length,
                        itemBuilder: (context, index) {
                          final item = othersList[index];

                          final from = item['fromMember']?['personalDetails'];
                          final to = item['toMember']?['personalDetails'];

                          final fromName =
                              '${from?['firstName'] ?? ''} ${from?['lastName'] ?? ''}';
                          final toName =
                              '${to?['firstName'] ?? ''} ${to?['lastName'] ?? ''}';

                          final metWith =
                              item['createdBy'] == item['fromMember']['_id']
                                  ? toName
                                  : fromName;

                          final date = _formatDate(item['date']);
                          final address = item['address'] ?? 'No address';

                          final hasImages = item['images'] != null &&
                              item['images'].isNotEmpty;
                          final imageUrl = hasImages
                              ? "$imageBaseUrl/${item['images'][0]['docPath']}/${item['images'][0]['docName']}"
                              : null;

                          return InkWell(
                            onTap: () {
                              context.push('/Givenonetoonepage', extra: item);
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 1,
                              margin: EdgeInsets.symmetric(vertical: 0.4.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage(
                                                  'assets/images/default_profile.jpg')
                                              as ImageProvider,
                                      radius: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "MET WITH: ",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFFC6221A),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: metWith,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Text(
                                            date,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: const Color(0xFFC6221A),
                                    ),
                                  ],
                                ),
                              ),
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
