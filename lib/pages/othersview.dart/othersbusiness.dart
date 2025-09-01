import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OthersThankyouViewPage extends StatefulWidget {
  final String memberId;
  final String memberName;

  const OthersThankyouViewPage({
    super.key,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<OthersThankyouViewPage> createState() => _ThankyouViewPageState();
}

class _ThankyouViewPageState extends State<OthersThankyouViewPage> {
  bool _isLoading = false;
  List<dynamic> givenNotes = [];
  List<dynamic> filteredNotes = [];
  FilterOptions filter = FilterOptions();

  String? buildImageUrl(Map<String, dynamic>? image) {
    if (image == null) return null;
    final docPath = image['docPath'];
    final docName = image['docName'];
    if (docPath == null || docName == null) return null;
    return "${UrlService.imageBaseUrl}/$docPath/$docName";
  }

  @override
  void initState() {
    super.initState();
    _loadGivenThankYouNotes();
  }

  Future<void> _loadGivenThankYouNotes() async {
    setState(() => _isLoading = true);

    final response =
        await PublicRoutesApiService.fetchotherGivenThankYouNotes(widget.memberId);

    if (response.isSuccess && response.data is List) {
      givenNotes = response.data;
      filteredNotes = List.from(givenNotes);
    }

    setState(() => _isLoading = false);
  }

  void applyFilters() {
    setState(() {
      filteredNotes = givenNotes.where((item) {
        final dateStr = item['createdAt']?.toString();
        final date = DateTime.tryParse(dateStr ?? '');
        return date != null && filter.isWithinRange(date);
      }).toList();
    });
  }

  Future<void> openFilterDialog() async {
    final result = await showGeneralDialog<FilterOptions>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: 60,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: FilterDialog(initialFilter: filter),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() => filter = result);
      applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredNotes;

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
                  Row(
                    children: [
                      Text('Business Given', style: TTextStyles.ReferralSlip),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/handshake.png',
                        width: 34,
                        height: 34,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: openFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0E2E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.filter_alt_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                        ? const Center(child: Text('No data found.'))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              final name =
                                  "${item['toMember']?['personalDetails']?['firstName'] ?? ''} ${item['toMember']?['personalDetails']?['lastName'] ?? ''}";
                              final rawDate = item['createdAt'];
                              final formattedDate = rawDate != null
                                  ? DateFormat('dd-MM-yy')
                                      .format(DateTime.parse(rawDate))
                                  : '';
                              final profileImageMap =
                                  getProfileImageMap(item);
                              final imageUrl = buildImageUrl(profileImageMap);

                              return referralTile(
                                  name, formattedDate, imageUrl, item);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? getProfileImageMap(dynamic item) {
    final member = item['toMember'] as Map<String, dynamic>?;
    final personalDetails = member?['personalDetails'] as Map<String, dynamic>?;
    return personalDetails?['profileImage'] as Map<String, dynamic>?;
  }

  Widget referralTile(
      String name, String date, String? imageUrl, dynamic item) {
    return GestureDetector(
      onTap: () {
        context.push('/Giventhankyou', extra: item);
      },
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
              CircleAvatar(
                radius: 20,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/person.png')
                        as ImageProvider,
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(date,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
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
