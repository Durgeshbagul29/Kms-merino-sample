// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_bottom_navigation.dart'; // Changed to admin bottom navigation
import 'package:kmsmerino/views/screens/auth/error_page.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';

import 'package:kmsmerino/views/base/error_message.dart';
// import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/hr/hr_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/user/user_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/manager/manager_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/director/director_bottom_navigation.dart';
import 'package:kmsmerino/models/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    debugPrint("HomePage initState called");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage build called");

    // int userroleid = LoggedInUser.getUserRoleId();
    // return userroleid==1 ? AdminDashboard() : userroleid==2 ? HrDashboard() : userroleid==3 ? UserDashboard() : ErrorPage();

    // return widget.roleid==1 ? AdminDashboard() : widget.roleid==2 ? HrDashboard() : UserDashboard();
    return FutureBuilder<UserData>(
      future: LoggedInUser.getAllUserData(),
      builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
        debugPrint("FutureBuilder snapshot state: ${snapshot.connectionState}");
        debugPrint("FutureBuilder hasData: ${snapshot.hasData}");
        debugPrint("FutureBuilder hasError: ${snapshot.hasError}");
        debugPrint("FutureBuilder error: ${snapshot.error}");
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint(
            "FutureBuilder done, hasError: ${snapshot.hasError}, hasData: ${snapshot.hasData}",
          );
          if (snapshot.hasError) {
            debugPrint("FutureBuilder error: ${snapshot.error.toString()}");
            return Scaffold(
              body: errorWidgetDesign(context, snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            debugPrint("FutureBuilder role ID: ${userData.roleId}");
            if (userData.roleId == 1) {
              debugPrint(
                "Creating AdminBottomNavigation for role ID: ${userData.roleId}",
              );
              return AdminBottomNavigation();
            } else if (userData.roleId == 2) {
              debugPrint(
                "Creating HrBottomNavigation for role ID: ${userData.roleId}",
              );
              return HrBottomNavigation();
            } else if (userData.roleId == 3) {
              debugPrint(
                "Creating UserBottomNavigation for role ID: ${userData.roleId}",
              );
              return UserBottomNavigation();
            } else if (userData.roleId == 5) {
              debugPrint(
                "Creating ManagerBottomNavigation for role ID: ${userData.roleId}",
              );
              return ManagerBottomNavigation();
            } else if (userData.roleId == 4) {
              debugPrint(
                "Creating DirectorBottomNavigation for role ID: ${userData.roleId}",
              );
              return DirectorBottomNavigation();
            } else {
              debugPrint(
                "Creating ErrorPage for unknown role ID: ${userData.roleId}",
              );
              Widget dashboard = ErrorPage();
              debugPrint("Dashboard widget created successfully");
              return dashboard;
            }
          } else {
            debugPrint("FutureBuilder has no data, showing ErrorPage");
            return ErrorPage();
          }
        }
        // While loading user data, show empty container to avoid flickering
        return Container();
      },
    );

    // return userroleid==1 ? AdminDashboard() : userroleid==2? HrDashboard : userroleid==3? UserDashboard() : ErrorPage();
  }
}
