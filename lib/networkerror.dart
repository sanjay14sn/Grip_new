import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class Networkerror extends StatelessWidget {
  const Networkerror({super.key});

  Future<void> _retryConnection(BuildContext context) async {
    final result = await Connectivity().checkConnectivity();
    final hasInternet = await _checkInternet();

    if (result != ConnectivityResult.none && hasInternet) {
      context.go('/homepage'); // or your actual destination
    } else {
      ToastUtil.showToast(
          context, 'Still offline. Please check your connection.');
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.w),
                bottomRight: Radius.circular(6.w),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Text(
                  "Uh-Oh!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20), // or use 5.w if you're using Sizer
                  child: Text(
                    "It Looks Like You’re Offline. Please Check Your Internet Connection And Try Again.",
                    textAlign: TextAlign.center,
                    style: TTextStyles.networkerror,
                  ),
                ),
                SizedBox(height: 2.h),
                Image.asset(
                  "assets/images/no_internet.png",
                  width:
                      100.w, // maintain aspect ratio (width ~60%, height ~40%)
                  height: 60.w,
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                ),
                onPressed: () => _retryConnection(context),
                child: Text(
                  "Retry",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
