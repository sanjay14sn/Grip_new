import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/constants/Timages.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();

    // You can perform splash logic here (e.g., auth check)
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      // Optional: Navigate automatically
      // context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Tcolors.red_gradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 40.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 65.h,
                      width: 65.w,
                      child: Image(
                        image: AssetImage(Timages.worldperson),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            Timages.hanadshake,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            Timages.bulb,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Global Referral Interacting Platform",
                style: TTextStyles.onboradtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "GRIP redefines how professionals in a rapidly evolving digital landscape. "
                "It provides the platform to expand your network and drive engagement",
                style: TTextStyles.onboradsubtitle,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: GestureDetector(
                onTap: () {
                  context.push('/login');
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Center(
                    child: Text(
                      "Get started",
                      style: TTextStyles.bodycontentmediam,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
