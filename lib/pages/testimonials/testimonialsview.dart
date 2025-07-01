import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Testimonialsviewpage extends StatefulWidget {
  final List<dynamic> testimonials;

  const Testimonialsviewpage({super.key, required this.testimonials});

  @override
  State<Testimonialsviewpage> createState() => _TestimonialsviewpageState();
}

class _TestimonialsviewpageState extends State<Testimonialsviewpage> {
  bool isReceivedSelected = false;
  late List<dynamic> givenReferrals;
  List<dynamic> receivedReferrals = [];

  List<dynamic> filteredGivenReferrals = [];
  List<dynamic> filteredReceivedReferrals = [];

  FilterOptions filter = FilterOptions();

  @override
  void initState() {
    super.initState();
    givenReferrals = widget.testimonials;
    filteredGivenReferrals = List.from(givenReferrals);
    _loadReceivedTestimonials();
  }

  Future<void> _loadReceivedTestimonials() async {
    final response = await PublicRoutesApiService.getTestimonialReceivedList();

    if (response.isSuccess && mounted) {
      setState(() {
        receivedReferrals = response.data ?? [];
        filteredReceivedReferrals = List.from(receivedReferrals);
      });
    }
  }

  void applyFilters() {
    if (filter.category == 'Given') {
      setState(() {
        filteredGivenReferrals = givenReferrals.where((item) {
          final dateStr = item['createdAt']?.toString();
          final date = DateTime.tryParse(dateStr ?? '');
          return date != null && filter.isWithinRange(date);
        }).toList();
      });
    } else {
      setState(() {
        filteredReceivedReferrals = receivedReferrals.where((item) {
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
    final activeList =
        isReceivedSelected ? filteredReceivedReferrals : filteredGivenReferrals;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔙 Top Bar
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

              /// 🧾 Title
              Row(
                children: [
                  Text('Testimonials Details', style: TTextStyles.ReferralSlip),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/fluent_person-feedback-16-filled.png',
                    width: 34,
                    height: 34,
                  )
                ],
              ),

              SizedBox(height: 1.5.h),

              Text('Category:', style: TTextStyles.Category),
              SizedBox(height: 1.h),

              /// Toggle Buttons
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

              /// 📋 Testimonial List
              Expanded(
                child: activeList.isEmpty
                    ? Center(
                        child: Text(
                          "No ${isReceivedSelected ? "received" : "given"} testimonials",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: activeList.length,
                        itemBuilder: (context, index) {
                          final item = activeList[index];
                          final person = isReceivedSelected
                              ? item['fromMember']
                              : item['toMember'];

                          final name =
                              "${person?['personalDetails']?['firstName'] ?? ''} ${person?['personalDetails']?['lastName'] ?? ''}"
                                  .trim();
                          final rawDate = item['createdAt'];
                          DateTime? parsedDate;
                          try {
                            parsedDate = rawDate != null
                                ? DateTime.parse(rawDate)
                                : null;
                          } catch (_) {
                            parsedDate = null;
                          }

                          final date = parsedDate != null
                              ? DateFormat('dd-MM-yy').format(parsedDate)
                              : '';

                          final profile = person?['personalDetails'];
                          final profileImage = profile?['profileImage'];
                          final docPath = profileImage?['docPath'];
                          final docName = profileImage?['docName'];

                          final imageUrl = (docPath != null && docName != null)
                              ? "${UrlService.imageBaseUrl}/$docPath/$docName"
                              : '';

                          return referralTile(
                            name,
                            date,
                            'assets/images/profile_placeholder.png',
                            isReceivedSelected,
                            imageUrl,
                            item,
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
    String name,
    String date,
    String fallbackImage,
    bool isReceived,
    String imageUrl,
    Map<String, dynamic> item,
  ) {
    return GestureDetector(
      onTap: () {
        final route = isReceived ? '/Recivedtestimonial' : '/GivenTestimonials';
        context.push(route, extra: item);
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
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage(fallbackImage) as ImageProvider,
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
