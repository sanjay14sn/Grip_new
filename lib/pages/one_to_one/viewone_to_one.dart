import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/components/filter.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/backend/api-requests/imageurl.dart';

class onetooneviewpage extends StatefulWidget {
  final List<dynamic> oneToOneList;

  const onetooneviewpage({super.key, required this.oneToOneList});

  @override
  State<onetooneviewpage> createState() => _onetooneviewpageState();
}

class _onetooneviewpageState extends State<onetooneviewpage> {
  bool isReceivedSelected = false;
  List<dynamic> filteredList = [];
  FilterOptions filter = FilterOptions();

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.oneToOneList);
  }

  void applyFilters() {
    setState(() {
      filteredList = widget.oneToOneList.where((item) {
        final dateStr = item['date']?.toString();
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
                child: FilterDialog(
                  initialFilter: filter,
                  showCategory: false,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        filter = result;
      });
      applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),

            // Top bar
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

            // Title
            Row(
              children: [
                Text('One to Ones', style: TTextStyles.ReferralSlip),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/testimonials.png',
                  width: 34,
                  height: 34,
                )
              ],
            ),

            SizedBox(height: 1.5.h),

            // Category Toggle
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
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              !isReceivedSelected ? Tcolors.red_button : null,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'My One to Ones',
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
                      onTap: () => context.push('/ViewOthers'),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              isReceivedSelected ? Tcolors.red_button : null,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'View Others',
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

            // SizedBox(height: 2.h),

            // One to One List
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text('No data found.'))
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        final toMember = item['toMember'] ?? {};
                        final personalDetails =
                            toMember['personalDetails'] ?? {};
                        final name =
                            "${personalDetails['firstName'] ?? 'Unknown'} ${personalDetails['lastName'] ?? ''}"
                                .trim();

                        final profileImage = personalDetails['profileImage']
                                as Map<String, dynamic>? ??
                            {};
                        final profileDocName = profileImage['docName'];
                        final profileDocPath = profileImage['docPath'];
                        final profileImageUrl = (profileDocName != null &&
                                profileDocPath != null)
                            ? "${UrlService.imageBaseUrl}/$profileDocPath/$profileDocName"
                            : null;

                        final rawDate = item['date'];
                        final formattedDate = rawDate != null
                            ? DateFormat('dd-MM-yyyy')
                                .format(DateTime.parse(rawDate))
                            : '';

                        return referralTile(
                          item,
                          name,
                          formattedDate,
                          profileImageUrl,
                          isReceivedSelected,
                        );
                      },
                    ),
            ),

            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget referralTile(
    Map<String, dynamic> item,
    String name,
    String date,
    String? imageUrl,
    bool isReceivedSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (isReceivedSelected) {
          context.push('/ViewOthers');
        } else {
          context.push('/Givenonetoonepage', extra: item);
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
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/images/profile1.jpg') as ImageProvider,
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
