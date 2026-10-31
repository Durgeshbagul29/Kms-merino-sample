import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/views/base/splash_screen.dart';
import 'package:kmsmerino/views/screens/auth/home_page.dart';
import 'package:kmsmerino/views/screens/auth/login.dart';
import 'package:kmsmerino/views/screens/director/director_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/manager/manager_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/user/user_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/hr/hr_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/admin/admin_bottom_navigation.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String userMain = '/user-main';
  static const String hrMain = '/hr-main';
  static const String adminMain = '/admin-main';
  static const String managerMain = '/manager-main';
  static const String directorMain = '/director-main';

  static const String main = '/main';
  static const String orderDetails = '/order-details';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signIn, page: () => Login()),
    GetPage(name: userMain, page: () => UserBottomNavigation()),
    GetPage(name: hrMain, page: () => HrBottomNavigation()),
    GetPage(name: adminMain, page: () => AdminBottomNavigation()),
    GetPage(name: managerMain, page: () => ManagerBottomNavigation()),
    GetPage(name: directorMain, page: () => DirectorBottomNavigation()),
  ];

  static Widget getRoute(Widget navigateTo) {
    return navigateTo;
  }
}