import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/helper/route_helper.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Reduced splash time for better UX
    Timer(Duration(seconds: 2), () {
      _checkRoutingStatus();
    });
  }

  Future<void> _checkRoutingStatus() async {
    debugPrint("=== Splash Screen Routing Logic ===");

    // Check login status
    bool isLoggedIn = await LoggedInUser.getLoggedInStatus();
    int? userRoleId = await LoggedInUser.getUserRoleId();

    debugPrint("Is Logged In: $isLoggedIn");
    debugPrint("User Role ID: $userRoleId");

    // Routing Logic:
    // 1. If not logged in -> login screen
    // 2. If logged in -> role-based dashboard

    if (!isLoggedIn) {
      debugPrint("Not logged in. Redirecting to login...");
      Get.offAllNamed(RouteHelper.signIn);
      return;
    }

    // User is logged in, navigate based on role
    debugPrint("User is logged in. Redirecting to role-based dashboard...");
    _navigateToRoleDashboard(userRoleId);
  }

  void _navigateToRoleDashboard(int? userRoleId) {
    debugPrint("Navigating to dashboard for role ID: $userRoleId");

    if (userRoleId == 1) {
      // Admin user
      Get.offAllNamed(RouteHelper.adminMain);
    } else if (userRoleId == 2) {
      // HR user
      Get.offAllNamed(RouteHelper.hrMain);
    } else if (userRoleId == 3) {
      // Regular user
      Get.offAllNamed(RouteHelper.userMain);
    } else if (userRoleId == 5) {
      // Manager user
      Get.offAllNamed(RouteHelper.managerMain);
    } else if (userRoleId == 4) {
      // Director user
      Get.offAllNamed(RouteHelper.directorMain);
    } else {
      // Unknown role, redirect to login
      debugPrint("Unknown role ID: $userRoleId. Redirecting to login...");
      Get.offAllNamed(RouteHelper.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Theme.of(context).primaryColor,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(2), // White border width
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/icon.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Merino KMS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kaizen Management System',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
