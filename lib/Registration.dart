import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPaymentItems();
  }

  Future<void> fetchPaymentItems() async {
    try {
      final response = await PublicRoutesApiService.fetchPayments();

      if (response.isSuccess && response.data is List) {
        final dataList = response.data as List<dynamic>;
        final items = dataList.map((e) => PaymentItem.fromJson(e)).toList();

        setState(() {
          _items = items;
          _isLoading = false;
        });
      } else {
        setState(() {
          _items = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _items = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Tcolors.title_color,
        title: Text(
          'Payment',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.all(3.w),
        child: _isLoading
            ? _buildShimmerList()
            : _items.isEmpty
                ? const Center(child: Text("No payments available."))
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.w),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) => SizedBox(height: 2.h),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return PaymentCard(
                                item: item,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _buildSubscriptionCard(context),
                    ],
                  ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 2.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 10.h,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.w,
                      height: 2.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: 30.w,
                      height: 2.h,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                width: 18.w,
                height: 3.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    final isActive = true; // You can update this dynamically

    return GestureDetector(
      onTap: () {
        // context.push('/membershipdetails');
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Icon(Icons.verified_user, size: 6.w, color: Colors.grey),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Subscription",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  SizedBox(height: 0.5.h),
                  Text(
                    isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentItem {
  final String id;
  final String title;
  final String? imageUrl;
  final int amount;
  final DateTime date;
  final bool paymentRequired;

  PaymentItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.amount,
    required this.date,
    required this.paymentRequired,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    final imageObj = json['image'];
    final imagePath = (imageObj != null)
        ? "${UrlService.imageBaseUrl}/${imageObj['docPath']}/${imageObj['docName']}"
        : null;

    return PaymentItem(
      id: json['_id'] ?? '',
      title: json['topic'] ?? json['purpose'] ?? 'No Title',
      imageUrl: imagePath,
      amount: json['amount'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      paymentRequired: json['paymentRequired'] ?? false,
    );
  }
}

class PaymentCard extends StatelessWidget {
  final PaymentItem item;
  final VoidCallback onTap;

  const PaymentCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(item.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3.w),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.imageUrl != null
                  ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.receipt_long, size: 6.w, color: Colors.grey),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  SizedBox(height: 0.5.h),
                  Text(formattedDate,
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("\u20B9 ${item.amount}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: 1.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
