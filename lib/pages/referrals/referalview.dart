import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ReferralDetailsPage extends StatefulWidget {
  final List<dynamic> referrals;

  const ReferralDetailsPage({super.key, required this.referrals});

  @override
  State<ReferralDetailsPage> createState() => _ReferralDetailsPageState();
}

class _ReferralDetailsPageState extends State<ReferralDetailsPage> {
  bool isReceivedSelected = false;
  late List<dynamic> originalGivenReferrals;
  late List<dynamic> givenReferrals;
  List<dynamic> receivedReferrals = [];
  List<dynamic> originalReceivedReferrals = [];
  bool isLoadingReceived = false;

  FilterOptions filter = FilterOptions();

  @override
  void initState() {
    super.initState();
    originalGivenReferrals = widget.referrals;
    givenReferrals = List.from(originalGivenReferrals);
    loadReceivedReferrals();
  }

  Future<void> loadReceivedReferrals() async {
    setState(() => isLoadingReceived = true);

    final response = await PublicRoutesApiService.fetchReceivedReferralSlips();

    if (response.isSuccess && response.data is List) {
      setState(() {
        originalReceivedReferrals = response.data;
        receivedReferrals = List.from(originalReceivedReferrals);
      });
    } else {
      ToastUtil.showToast(context, response.message);
    }

    setState(() => isLoadingReceived = false);
  }

  void applyFilters() {
    if (filter.category == 'Given') {
      setState(() {
        givenReferrals = originalGivenReferrals.where((item) {
          final dateStr = item['createdAt']?.toString();
          final date = DateTime.tryParse(dateStr ?? '');
          return date != null && filter.isWithinRange(date);
        }).toList();
      });
    } else {
      setState(() {
        receivedReferrals = originalReceivedReferrals.where((item) {
          final dateStr = item['createdAt']?.toString();
          final date = DateTime.tryParse(dateStr ?? '');
          return date != null && filter.isWithinRange(date);
        }).toList();
      });
    }
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
      setState(() {
        filter = result;
        isReceivedSelected = result.category == 'Received';
      });
      applyFilters();
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
                  Row(
                    children: [
                      Text('Referral Details', style: TTextStyles.ReferralSlip),
                      const SizedBox(width: 8),
                      const Icon(Icons.people),
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
                  )
                ],
              ),
              SizedBox(height: 2.h),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          isReceivedSelected = false;
                          filter.category = 'Given';
                          applyFilters();
                        }),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          isReceivedSelected = true;
                          filter.category = 'Received';
                          applyFilters();
                        }),
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
              Expanded(
                child: isReceivedSelected
                    ? isLoadingReceived
                        ? const Center(child: CircularProgressIndicator())
                        : receivedReferrals.isEmpty
                            ? const Center(
                                child: Text("No received referrals"),
                              )
                            : ListView.builder(
                                itemCount: receivedReferrals.length,
                                itemBuilder: (context, index) {
                                  final item = receivedReferrals[index];
                                  final detail = item['referalDetail'] ?? {};
                                  final name = detail['name'] ?? 'No Name';
                                  final rawDate = item['createdAt'];
                                  final date = rawDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(DateTime.parse(rawDate))
                                      : '';

                                  final fromDetails = item['fromMember']
                                          ?['personalDetails'] ??
                                      {};
                                  final fromName =
                                      "${fromDetails['firstName'] ?? ''} ${fromDetails['lastName'] ?? ''}"
                                          .trim();
                                  return referralTile(
                                    item,
                                    fromName.isNotEmpty ? fromName : name,
                                    date,
                                    'assets/images/profile_placeholder.png',
                                    true,
                                  );
                                },
                              )
                    : givenReferrals.isEmpty
                        ? const Center(child: Text("No given referrals"))
                        : ListView.builder(
                            itemCount: givenReferrals.length,
                            itemBuilder: (context, index) {
                              final item = givenReferrals[index];
                              final detail = item['referalDetail'] ?? {};
                              final name = detail['name'] ?? 'No Name';
                              final rawDate = item['createdAt'];
                              final date = rawDate != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(DateTime.parse(rawDate))
                                  : '';

                              final toDetails =
                                  item['toMember']?['personalDetails'] ?? {};
                              final toName =
                                  "${toDetails['firstName'] ?? ''} ${toDetails['lastName'] ?? ''}"
                                      .trim();
                              return referralTile(
                                item,
                                toName.isNotEmpty ? toName : name,
                                date,
                                'assets/images/profile_placeholder.png',
                                false,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
      ),
    );
  }
}
