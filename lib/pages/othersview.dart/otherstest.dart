import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grip/components/shimmer.dart';


class OthersTestimonialsViewPage extends StatefulWidget {
  final String memberName;
  final String memberId;

  const OthersTestimonialsViewPage({
    super.key,
    required this.memberName,
    required this.memberId,
  });

  @override
  State<OthersTestimonialsViewPage> createState() =>
      _OthersTestimonialsViewPageState();
}

class _OthersTestimonialsViewPageState
    extends State<OthersTestimonialsViewPage> {
  bool isReceivedSelected = false;

  List<dynamic> givenTestimonials = [];
  List<dynamic> receivedTestimonials = [];

  List<dynamic> filteredGivenTestimonials = [];
  List<dynamic> filteredReceivedTestimonials = [];

  bool isLoading = false;

  FilterOptions filter = FilterOptions();

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
  }

  Future<void> _loadTestimonials({int maxRetries = 3}) async {
    setState(() => isLoading = true);

    int attempt = 0;
    bool success = false;

    while (attempt < maxRetries && !success) {
      attempt++;

      try {
        final givenRes = await PublicRoutesApiService.fetchGivenTestimonials(
            widget.memberId);
        final receivedRes =
            await PublicRoutesApiService.fetchReceivedTestimonials(
                widget.memberId);

        if (!mounted) return;

        if (givenRes.isSuccess && receivedRes.isSuccess) {
          setState(() {
            givenTestimonials = givenRes.data ?? [];
            filteredGivenTestimonials = List.from(givenTestimonials);

            receivedTestimonials = receivedRes.data ?? [];
            filteredReceivedTestimonials = List.from(receivedTestimonials);

            isLoading = false;
          });

          success = true;
        } else {
          if (attempt < maxRetries) {
            await Future.delayed(
                const Duration(seconds: 2)); // wait before retry
          } else {
            setState(() => isLoading = false);
          }
        }
      } catch (e) {
        if (attempt >= maxRetries) {
          if (!mounted) return;
          setState(() => isLoading = false);
        } else {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  void applyFilters() {
    if (filter.category == 'Given') {
      setState(() {
        filteredGivenTestimonials = givenTestimonials.where((item) {
          final date = DateTime.tryParse(item['createdAt'] ?? '');
          return date != null && filter.isWithinRange(date);
        }).toList();
      });
    } else {
      setState(() {
        filteredReceivedTestimonials = receivedTestimonials.where((item) {
          final date = DateTime.tryParse(item['createdAt'] ?? '');
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
    final activeList = isReceivedSelected
        ? filteredReceivedTestimonials
        : filteredGivenTestimonials;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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

              Row(
                children: [
                  Text('${widget.memberName}\'s Testimonials',
                      style: TTextStyles.ReferralSlip),
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

              /// Testimonial List
              Expanded(
                child: isLoading
                    ? buildShimmerList()
                    : activeList.isEmpty
                        ? Center(
                            child: Text(
                              "No ${isReceivedSelected ? "received" : "given"} testimonials",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: activeList.length,
                            itemBuilder: (context, index) {
                              final item = activeList[index];

                              final member = isReceivedSelected
                                  ? item['fromMember']
                                  : item['toMember'];

                              final name =
                                  "${member?['personalDetails']?['firstName'] ?? ''} ${member?['personalDetails']?['lastName'] ?? ''}";

                              final dateStr = item['createdAt'] ?? '';
                              final date = DateTime.tryParse(dateStr);
                              final formattedDate = date != null
                                  ? DateFormat('dd-MM-yy').format(date)
                                  : '';

                              final images = item['images'] as List?;
                              final imageUrl = (images != null &&
                                      images.isNotEmpty &&
                                      images[0]['docName'] != null)
                                  ? '${dotenv.env['API_BASE_URL']}/uploads/${images[0]['docPath']}/${images[0]['docName']}'
                                  : '';

                              return testimonialTile(
                                name: name,
                                date: formattedDate,
                                imagePath:
                                    'assets/images/profile_placeholder.png',
                                networkImage: imageUrl,
                                isReceived: isReceivedSelected,
                                data: item,
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

  Widget testimonialTile({
    required String name,
    required String date,
    required String imagePath,
    required String networkImage,
    required bool isReceived,
    required Map<String, dynamic> data,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(
          isReceived ? '/Recivedtestimonial' : '/GivenTestimonials',
          extra: data,
        );
      },
      child: Card(
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
                backgroundImage: networkImage.isNotEmpty
                    ? NetworkImage(networkImage)
                    : AssetImage(imagePath) as ImageProvider,
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
