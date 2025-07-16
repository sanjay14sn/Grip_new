import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final List<String> timeFilters = [
    '3 Months',
    '6 Months',
    '12 Months',
    'Overall'
  ];
  int selectedIndex = 0;

  Map<String, dynamic> dashboardData = {
    'referralGiven': 0,
    'referralReceived': 0,
    'thankyouGiven': 0,
    'thankyouReceived': 0,
    'testimonialGiven': 0,
    'testimonialReceived': 0,
    'onetoones': 0,
    'visitors': 0,
    'revenueGiven': 0,
    'revenueReceived': 0,
    'training': 0,
  };

  final Map<int, String> filterMap = {
    0: 'this-month',
    1: '6-months',
    2: '12-months',
    3: '', // Life time
  };

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    final filterType = filterMap[selectedIndex]!;

    final response = await PublicRoutesApiService.fetchDashboardCount(
        filterType: filterType);

    if (response.isSuccess && response.data != null) {
      final raw = response.data;

      setState(() {
        dashboardData = {
          'referralGiven': raw['referralGivenCount'] ?? 0,
          'referralReceived': raw['referralReceivedCount'] ?? 0,
          'thankyouGiven': raw['thankYouGivenCount'] ?? 0,
          'thankyouReceived': raw['thankYouReceivedCount'] ?? 0,
          'testimonialGiven': raw['testimonialGivenCount'] ?? 0,
          'testimonialReceived': raw['testimonialReceivedCount'] ?? 0,
          'onetoones': raw['oneToOneCount'] ?? 0,
          'visitors': raw['visitorCount'] ?? 0,
          'revenueGiven': raw['thankYouGivenAmount'] ?? 0,
          'revenueReceived': raw['thankYouReceivedAmount'] ?? 0,
          'training': raw['trainingCount'] ?? 0,
        };
      });
    } else {}
  }

  String formatIndianNumber(num number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr'; // Crore
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L'; // Lakh
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K'; // Thousand
    } else {
      return number.toString();
    }
  }

  Widget _buildTimeFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(timeFilters.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              _fetchDashboardData();
            },
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(timeFilters[index], style: TTextStyles.month),
                ),
                SizedBox(height: 0.2.h),
                Container(
                  height: 0.35.h,
                  width: 8.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFC6221A)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC6221A), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: Colors.black87),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(title,
                    style: TTextStyles.month, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(value, style: TTextStyles.CatNUM),
          )
        ],
      ),
    );
  }

  String truncateValue(String text, [int maxLength = 22]) {
    return (text.length > maxLength)
        ? '${text.substring(0, maxLength)}…'
        : text;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> statData = [
      {
        'title': 'One-to-One',
        'value': 'Total ${dashboardData['onetoones']}',
        'icon': Icons.group,
      },
      {
        'title': 'Referral',
        'value':
            'Given ${dashboardData['referralGiven']} / Received ${dashboardData['referralReceived']}',
        'icon': Icons.compare_arrows,
      },
      {
        'title': 'Visitors',
        'value': 'Total ${dashboardData['visitors']}',
        'icon': Icons.desktop_windows,
      },
      {
        'title': 'Business Given',
        'value': truncateValue(
            'Amount ₹${formatIndianNumber(dashboardData['revenueGiven'])}'),
        'icon': Icons.currency_rupee_sharp,
      },
      {
        'title': 'Business Received',
        'value': truncateValue(
          'Amount ₹${formatIndianNumber(dashboardData['revenueReceived'])}',
        ),
        'icon': Icons.currency_rupee_sharp,
      },
      {
        'title': 'Learnings',
        'value': 'Total ${dashboardData['training']}',
        'icon': Icons.person,
      },
    ];

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeFilter(),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              itemCount: statData.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.5.h,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final item = statData[index];
                return _buildStatCard(
                    item['title'], item['value'], item['icon']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
