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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _accentWidthAnimation;
  late Animation<double> _bottomFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.68, curve: Curves.easeIn),
      ),
    );

    _accentWidthAnimation = Tween<double>(begin: 0.0, end: 46.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _bottomFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Trigger routing after splash animation completes with comfortable display time (3.2s)
    _startRouting();
  }

  void _startRouting() {
    Timer(const Duration(milliseconds: 3200), () {
      if (mounted) {
        _checkRoutingStatus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkRoutingStatus() async {
    debugPrint("=== Splash Screen Routing Logic ===");

    // Check login status
    bool isLoggedIn = await LoggedInUser.getLoggedInStatus();
    int? userRoleId = await LoggedInUser.getUserRoleId();

    debugPrint("Is Logged In: $isLoggedIn");
    debugPrint("User Role ID: $userRoleId");

    if (!mounted) return;

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
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0A2342),
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A2342),
                Color(0xFF0D47A1),
                Color(0xFF1565C0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              // Subtle ambient background decorations
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -60,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1ED7AA).withValues(alpha: 0.05),
                  ),
                ),
              ),

              // Main strictly centered animated content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animated Logo
                      ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: FadeTransition(
                          opacity: _logoFadeAnimation,
                          child: Image.asset(
                            'assets/icon.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Animated App Name & Subtitle
                      SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Merino KMS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _accentWidthAnimation,
                                builder: (context, child) {
                                  return Container(
                                    width: _accentWidthAnimation.value,
                                    height: 3,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF1ED7AA),
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'KAIZEN MANAGEMENT SYSTEM',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2.2,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Animated Bottom Loading Indicator & Caption (pinned to bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 36,
                child: SafeArea(
                  top: false,
                  child: FadeTransition(
                    opacity: _bottomFadeAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Empowering Continuous Improvement',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
