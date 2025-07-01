import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/shimmer.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class OtherReferralViewPage extends StatefulWidget {
  final String memberId;
  final String memberName;

  const OtherReferralViewPage({
    super.key,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<OtherReferralViewPage> createState() => _OtherReferralViewPageState();
}

class _OtherReferralViewPageState extends State<OtherReferralViewPage> {
  bool isReceivedSelected = false;
  bool isLoading = true;

  List<dynamic> receivedReferrals = [];
  List<dynamic> givenReferrals = [];

  @override
  void initState() {
    super.initState();
    fetchReferrals();
  }

  Future<void> fetchReferrals() async {
    final givenResponse =
        await PublicRoutesApiService.fetchGivenReferrals(widget.memberId);
    final receivedResponse =
        await PublicRoutesApiService.fetchReceivedReferrals(widget.memberId);

    setState(() {
      givenReferrals = givenResponse.data ?? [];
      receivedReferrals = receivedResponse.data ?? [];
      isLoading = false;
    });
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
                  const SizedBox(width: 12),
                  Text('${widget.memberName}\'s Referrals',
                      style: TTextStyles.ReferralSlip),
                ],
              ),
              SizedBox(height: 2.h),

              // Title
              Row(
                children: [
                  Text('Referral Details', style: TTextStyles.ReferralSlip),
                  const SizedBox(width: 8),
                  const Icon(Icons.people),
                ],
              ),
              SizedBox(height: 1.5.h),

              // Toggle
              Text('Category:', style: TTextStyles.Category),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // GIVEN
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = false),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                !isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Given',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // RECEIVED
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isReceivedSelected = true),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                                isReceivedSelected ? Tcolors.red_button : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Received',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isReceivedSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // List or shimmer
              Expanded(
                child: isLoading
                    ? buildShimmerList()
                    : ListView.builder(
                        itemCount: isReceivedSelected
                            ? receivedReferrals.length
                            : givenReferrals.length,
                        itemBuilder: (context, index) {
                          final item = isReceivedSelected
                              ? receivedReferrals[index]
                              : givenReferrals[index];

                          final referralName =
                              '${item['toMember']?['personalDetails']?['firstName'] ?? ''} ${item['toMember']?['personalDetails']?['lastName'] ?? ''}'
                                  .trim();

                          final dateRaw = item['createdAt'];
                          final date = _formatDate(dateRaw);

                          return referralTile(
                            item,
                            referralName,
                            date,
                            'assets/images/profile1.jpg',
                            isReceivedSelected,
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

  /// Format ISO date to dd-MM-yy
  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      return DateFormat('dd-MM-yy').format(dt);
    } catch (_) {
      return '';
    }
  }

  /// Shimmer loading widget

  // Tile
  Widget referralTile(
    Map<String, dynamic> referral,
    String name,
    String date,
    String imagePath,
    bool isReceived,
  ) {
    return GestureDetector(
      onTap: () {
        if (isReceived) {
          context.push('/referralDetailReceived', extra: referral);
        } else {
          context.push('/referralDetailGiven', extra: referral);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 2.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
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
