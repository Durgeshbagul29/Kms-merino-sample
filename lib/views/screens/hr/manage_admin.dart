// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/screens/hr/change_password.dart';
import 'package:kmsmerino/views/screens/hr/hr_functions.dart';
import 'package:kmsmerino/views/screens/hr/update_user.dart';
import 'package:kmsmerino/views/screens/hr/user_details.dart';

class ManageAdmin extends StatefulWidget {
  const ManageAdmin({super.key});

  @override
  State<ManageAdmin> createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    // _getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Manage Admin',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: FutureBuilder<dynamic>(
            future: getUserData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return errorWidgetDesign(context, snapshot.error.toString());
                } else if (snapshot.hasData) {
                  dynamic response = snapshot.data;
                  return response['success'] == true
                      ? response['data'] != null
                            ? Column(
                                children: [
                                  // Header section
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade700,
                                          Colors.blue.shade900,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.admin_panel_settings,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Admin Management',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Total Admins: ${response['data'].length}',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Admins list
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: response['data'].length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade100,
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withValues(alpha: 0.1,
                                                ),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(16),
                                            leading: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color:
                                                    response['data'][index]["status"] ==
                                                        1
                                                    ? Colors.green.withValues(alpha: 0.1,
                                                      )
                                                    : Colors.red.withValues(alpha: 0.1,
                                                      ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.admin_panel_settings,
                                                  color:
                                                      response['data'][index]["status"] ==
                                                          1
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              response['data'][index]["name"] ??
                                                  'No Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  response['data'][index]["username"] ??
                                                      'No Username',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        response['data'][index]["status"] ==
                                                            1
                                                        ? Colors.green
                                                              .withValues(alpha: 0.1)
                                                        : Colors.red
                                                              .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    response['data'][index]["status"] ==
                                                            1
                                                        ? "Active"
                                                        : "Inactive",
                                                    style: TextStyle(
                                                      color:
                                                          response['data'][index]["status"] ==
                                                              1
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: PopupMenuButton<int>(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              onSelected: (int value) {
                                                switch (value) {
                                                  case 1:
                                                    // View Details
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserDetail(
                                                              response['data'][index],
                                                              ManageAdmin(),
                                                            ),
                                                      ),
                                                    );
                                                    break;
                                                  case 2:
                                                    // Edit Details
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateUser(
                                                              response['data'][index],
                                                              ManageAdmin(),
                                                            ),
                                                      ),
                                                    );
                                                    break;
                                                  case 3:
                                                    // Change Password
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangePassword(
                                                              response['data'][index]['username'],
                                                              response['data'][index]['id'],
                                                              response['data'][index]['user_role_id'],
                                                              ManageAdmin(),
                                                            ),
                                                      ),
                                                    );
                                                    break;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.visibility,
                                                        size: 18,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text("View Details"),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text("Edit Details"),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.lock,
                                                        size: 18,
                                                        color: Colors.orange,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text("Change Password"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings_outlined,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No Admins Available",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "There are currently no admins in the system",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No Admins Available",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "There are currently no admins in the system",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                }
              }
              return Center(
                child: AnimatedDotsLoader(
                  text: 'Loading Admins...',
                  color: Theme.of(context).primaryColor,
                  size: 10.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
