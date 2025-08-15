import 'package:flutter/material.dart';
import 'package:grip/backend/providers/dashboard_provider.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  String formatIndianNumber(num number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  String truncateValue(String text, [int maxLength = 22]) {
    return (text.length > maxLength)
        ? '${text.substring(0, maxLength)}…'
        : text;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    final List<String> timeFilters = [
      '3 Months',
      '6 Months',
      '12 Months',
      'Overall'
    ];

    final dashboardData = provider.dashboardData;

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
            // Time Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(timeFilters.length, (index) {
                  final isSelected = provider.selectedIndex == index;
                  return GestureDetector(
                    onTap: () => provider.setFilter(index),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.6.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(timeFilters[index],
                              style: TTextStyles.month),
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
            ),
            SizedBox(height: 2.h),
            // Stats Grid
            GridView.builder(
              shrinkWrap: true,
              itemCount: statData.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.5.h,
                childAspectRatio: 2.3, // Slightly increased to avoid overflow
              ),
              itemBuilder: (context, index) {
                final item = statData[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFC6221A), width: 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2))
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item['icon'],
                              size: 14.sp, color: Colors.black87),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(item['title'],
                                style: TTextStyles.month,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(item['value'], style: TTextStyles.CatNUM),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
