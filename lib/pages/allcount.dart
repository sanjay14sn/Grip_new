import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final List<String> timeFilters = [
    '1 Month',
    '6 Month',
    '1 Year',
    'Life Time'
  ];
  int selectedIndex = 0;

  Widget _buildTimeFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(timeFilters.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    timeFilters[index],
                    style: TTextStyles.month,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Container(
                  height: 0.35.h,
                  width: 8.w,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFC6221A) : Colors.transparent,
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
        border: Border.all(
          color: Color(0xFFC6221A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
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
                child: Text(
                  title,
                  style: TTextStyles.month,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TTextStyles.CatNUM,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> statData = [
      {
        'title': 'Referral',
        'value': 'Given 5 / Received 8',
        'icon': Icons.compare_arrows
      },
      {
        'title': 'Thank u Notes',
        'value': 'Given 5 / Received 8',
        'icon': Icons.person
      },
      {
        'title': 'Testimonials',
        'value': 'Given 5 / Received 8',
        'icon': Icons.swap_horiz
      },
      {'title': 'One to Ones', 'value': 'Total 5', 'icon': Icons.group},
      {'title': 'Visitors', 'value': 'Total 2', 'icon': Icons.desktop_windows},
      {
        'title': 'Revenue',
        'value': 'Given 5898 / Received 86534',
        'icon': Icons.currency_rupee_sharp
      },
    ];

    return Padding(
      padding: EdgeInsets.only(top: 1.h), // Only top padding; no horizontal
      child: Container(
        width: double.infinity, // Makes container stretch full width
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
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
              physics: NeverScrollableScrollPhysics(),
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
